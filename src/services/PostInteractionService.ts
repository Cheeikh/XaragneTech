//@ts-ignore
import { PrismaClient, Post } from '@prisma/client';
import cloudinary from '../config/cloudinary.js';
import prisma from '../config/prisma.js';
export class PostInteractionService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;
    }

    async incrementViews(postId: number): Promise<Post> {
        return this.prisma.post.update({
            where: { id: postId },
            data: { vues: { increment: 1 } },
        });
    }

    async incrementShares(postId: number): Promise<Post> {
        return this.prisma.post.update({
            where: { id: postId },
            data: { partages: { increment: 1 } },
        });
    }

    async incrementDownloads(postId: number): Promise<Post> {
        return this.prisma.post.update({
            where: { id: postId },
            data: { telechargements: { increment: 1 } },
        });
    }

    async addLike(postId: number, userId: number): Promise<Post> {
        const post = await this.prisma.post.findUnique({
            where: { id: postId },
            include: {
                likes: true,
                dislikes: true,
            },
        });

        if (!post) {
            throw new Error('Post non trouvé');
        }

        const hasLiked = post.likes.some(user => user.id === userId);
        const hasDisliked = post.dislikes.some(user => user.id === userId);

        let updatedPost;

        if (hasLiked) {
            // Retirer le like si l'utilisateur a déjà liké
            updatedPost = await this.prisma.post.update({
                where: { id: postId },
                data: {
                    likes: {
                        disconnect: { id: userId },
                    },
                },
            });
        } else {
            const updateData: any = {
                likes: {
                    connect: { id: userId },
                },
            };

            if (hasDisliked) {
                // Retirer le dislike si l'utilisateur avait disliké
                updateData.dislikes = {
                    disconnect: { id: userId },
                };
            }

            // Ajouter le like
            updatedPost = await this.prisma.post.update({
                where: { id: postId },
                data: updateData,
            });
        }

        return updatedPost;
    }

    async addDislike(postId: number, userId: number): Promise<Post> {
        const post = await this.prisma.post.findUnique({
            where: { id: postId },
            include: {
                likes: true,
                dislikes: true,
            },
        });

        if (!post) {
            throw new Error('Post non trouvé');
        }

        const hasLiked = post.likes.some(user => user.id === userId);
        const hasDisliked = post.dislikes.some(user => user.id === userId);

        let updatedPost;

        if (hasDisliked) {
            // Retirer le dislike si l'utilisateur a déjà disliké
            updatedPost = await this.prisma.post.update({
                where: { id: postId },
                data: {
                    dislikes: {
                        disconnect: { id: userId },
                    },
                },
            });
        } else {
            const updateData: any = {
                dislikes: {
                    connect: { id: userId },
                },
            };

            if (hasLiked) {
                // Retirer le like si l'utilisateur avait liké
                updateData.likes = {
                    disconnect: { id: userId },
                };
            }

            // Ajouter le dislike
            updatedPost = await this.prisma.post.update({
                where: { id: postId },
                data: updateData,
            });
        }

        return updatedPost;
    }
}
