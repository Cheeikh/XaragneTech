import { PrismaClient, Discussion, Message, DiscussionStatus, MessageType } from '@prisma/client';
import prisma from '../config/prisma.js';

export class DiscussionsService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;
    }

    public async createDiscussion(clientId: number, tailleurId: number): Promise<Discussion> {
        try {
            return await this.prisma.discussion.create({
                data: { clientId, tailleurId },
            });
        } catch (error) {
            console.error('Error creating discussion:', error);
            throw new Error('Error creating discussion');
        }
    }

    public async getDiscussionById(id: number): Promise<Discussion | null> {
        try {
            return await this.prisma.discussion.findUnique({
                where: { id },
                include: { messages: true },
            });
        } catch (error) {
            console.error('Error retrieving discussion:', error);
            throw new Error('Error retrieving discussion');
        }
    }

    public async getDiscussionsByClientId(clientId: number): Promise<Discussion[]> {
        try {
            return await this.prisma.discussion.findMany({
                where: { clientId },
                include: { messages: { take: 1, orderBy: { createdAt: 'desc' } } },
                orderBy: { lastMessageAt: 'desc' },
            });
        } catch (error) {
            console.error('Error retrieving client discussions:', error);
            throw new Error('Error retrieving client discussions');
        }
    }

    public async getDiscussionsByTailleurId(tailleurId: number): Promise<Discussion[]> {
        try {
            return await this.prisma.discussion.findMany({
                where: { tailleurId },
                include: { messages: { take: 1, orderBy: { createdAt: 'desc' } } },
                orderBy: { lastMessageAt: 'desc' },
            });
        } catch (error) {
            console.error('Error retrieving tailor discussions:', error);
            throw new Error('Error retrieving tailor discussions');
        }
    }

    public async addMessage(
        discussionId: number, 
        auteurId: number, 
        contenu: string, 
        type: MessageType = MessageType.TEXT
    ): Promise<Message> {
        try {
            const discussion = await this.prisma.discussion.findUnique({ where: { id: discussionId } });

            if (!discussion) {
                throw new Error('Discussion not found');
            }

            return await this.prisma.$transaction(async (prisma) => {
                const message = await prisma.message.create({
                    data: { discussionId, auteurId, contenu, type },
                });

                await prisma.discussion.update({
                    where: { id: discussionId },
                    data: {
                        lastMessageAt: new Date(),
                        isReadByClient: auteurId === discussion.clientId,
                        isReadByTailleur: auteurId === discussion.tailleurId,
                    },
                });

                return message;
            });
        } catch (error) {
            console.error('Error adding message:', error);
            throw new Error('Error adding message');
        }
    }

    public async getMessagesByDiscussionId(
        discussionId: number, 
        page: number = 1, 
        pageSize: number = 20
    ): Promise<Message[]> {
        try {
            return await this.prisma.message.findMany({
                where: { discussionId },
                orderBy: { createdAt: 'desc' },
                skip: (page - 1) * pageSize,
                take: pageSize,
                include: { auteur: true },
            });
        } catch (error) {
            console.error('Error retrieving messages:', error);
            throw new Error('Error retrieving messages');
        }
    }

    public async updateDiscussionStatus(
        discussionId: number, 
        status: DiscussionStatus
    ): Promise<Discussion> {
        try {
            return await this.prisma.discussion.update({
                where: { id: discussionId },
                data: { status },
            });
        } catch (error) {
            console.error('Error updating discussion status:', error);
            throw new Error('Error updating discussion status');
        }
    }

    public async markMessagesAsRead(discussionId: number, userId: number): Promise<void> {
        try {
            const discussion = await this.prisma.discussion.findUnique({
                where: { id: discussionId },
            });
    
            if (!discussion) {
                throw new Error('Discussion not found');
            }
    
            const isClient = discussion.clientId === userId;
            const isTailleur = discussion.tailleurId === userId;
    
            if (!isClient && !isTailleur) {
                throw new Error('User not authorized to mark messages as read in this discussion');
            }
    
            await this.prisma.discussion.update({
                where: { id: discussionId },
                data: {
                    isReadByClient: isClient ? true : discussion.isReadByClient,
                    isReadByTailleur: isTailleur ? true : discussion.isReadByTailleur,
                },
            });
    
            // Optionally, you could also update the message status directly
            await this.prisma.message.updateMany({
                where: {
                    discussionId,
                    auteurId: {
                        not: userId, // Mark messages as read for messages not authored by the current user
                    },
                },
                data: {
                    isRead: true,
                },
            });
    
        } catch (error) {
            console.error('Error marking messages as read:', error);
            throw new Error('Error marking messages as read');
        }
    }
    

    public async getUnreadMessagesCount(
        userId: number
    ): Promise<{ clientUnread: number, tailleurUnread: number }> {
        try {
            const [clientUnread, tailleurUnread] = await Promise.all([
                this.prisma.discussion.count({
                    where: { clientId: userId, isReadByClient: false },
                }),
                this.prisma.discussion.count({
                    where: { tailleurId: userId, isReadByTailleur: false },
                }),
            ]);

            return { clientUnread, tailleurUnread };
        } catch (error) {
            console.error('Error counting unread messages:', error);
            throw new Error('Error counting unread messages');
        }
    }

    public async deleteMessage(
        messageId: number, 
        userId: number
    ): Promise<void> {
        try {
            const message = await this.prisma.message.findUnique({
                where: { id: messageId },
                include: { discussion: true },
            });
    
            if (!message) {
                throw new Error('Message not found');
            }
    
            const { discussion } = message;
            if (message.auteurId !== userId && discussion.clientId !== userId && discussion.tailleurId !== userId) {
                throw new Error('Unauthorized to delete this message');
            }
    
            await this.prisma.message.delete({
                where: { id: messageId },
            });
    
            // Update lastMessageAt if necessary
            const lastMessage = await this.prisma.message.findFirst({
                where: { discussionId: discussion.id },
                orderBy: { createdAt: 'desc' },
            });
    
            await this.prisma.discussion.update({
                where: { id: discussion.id },
                data: { lastMessageAt: lastMessage ? lastMessage.createdAt : undefined },
            });
        } catch (error) {
            console.error('Error deleting message:', error);
            throw new Error('Error deleting message');
        }
    }
    

    public async searchInDiscussion(
        discussionId: number, 
        searchTerm: string
    ): Promise<Message[]> {
        try {
            return await this.prisma.message.findMany({
                where: {
                    discussionId,
                    contenu: { contains: searchTerm }, // Remove 'mode'
                },
                orderBy: { createdAt: 'desc' },
                include: { auteur: true },
            });
        } catch (error) {
            console.error('Error searching in discussion:', error);
            throw new Error('Error searching in discussion');
        }
    }
    
    

    public async getDiscussionStats(
        userId: number
    ): Promise<{ totalDiscussions: number, activeDiscussions: number, archivedDiscussions: number }> {
        try {
            const [totalDiscussions, activeDiscussions, archivedDiscussions] = await Promise.all([
                this.prisma.discussion.count({
                    where: { OR: [{ clientId: userId }, { tailleurId: userId }] },
                }),
                this.prisma.discussion.count({
                    where: {
                        OR: [{ clientId: userId }, { tailleurId: userId }],
                        status: DiscussionStatus.ACTIVE,
                    },
                }),
                this.prisma.discussion.count({
                    where: {
                        OR: [{ clientId: userId }, { tailleurId: userId }],
                        status: DiscussionStatus.ARCHIVED,
                    },
                }),
            ]);

            return { totalDiscussions, activeDiscussions, archivedDiscussions };
        } catch (error) {
            console.error('Error retrieving discussion stats:', error);
            throw new Error('Error retrieving discussion stats');
        }
    }

    public async checkDiscussionAccess(discussionId: number, userId: number): Promise<boolean> {
        try {
            const discussion = await this.prisma.discussion.findUnique({
                where: { id: discussionId },
            });

            if (!discussion) {
                throw new Error('Discussion not found');
            }

            return discussion.clientId === userId || discussion.tailleurId === userId;
        } catch (error) {
            console.error('Error checking discussion access:', error);
            throw new Error('Error checking discussion access');
        }
    }

    public async getRecentDiscussions(userId: number, limit: number = 10): Promise<Discussion[]> {
        try {
            return await this.prisma.discussion.findMany({
                where: {
                    OR: [
                        { clientId: userId },
                        { tailleurId: userId }
                    ]
                },
                orderBy: { lastMessageAt: 'desc' },
                take: limit,
                include: {
                    messages: {
                        take: 1,
                        orderBy: { createdAt: 'desc' }
                    }
                }
            });
        } catch (error) {
            console.error('Error retrieving recent discussions:', error);
            throw new Error('Error retrieving recent discussions');
        }
    }
}
