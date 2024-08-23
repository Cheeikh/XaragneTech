import { PrismaClient, Story } from '@prisma/client';
import prisma from '../config/prisma.js';
import cloudinary from '../config/cloudinary.js';

export class StoryService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;
    }

    // Crée une nouvelle story
    async createStory(data: any, file: Express.Multer.File, tailleurId: number): Promise<Story> {
        try {
            const uploadResult = await new Promise<any>((resolve, reject) => {
                const uploadStream = cloudinary.uploader.upload_stream({ folder: 'story_files' }, (error, result) => {
                    if (error) reject(error);
                    resolve(result);
                });
                uploadStream.end(file.buffer);
            });

            const fileType = this.getFileType(uploadResult.secure_url);
            if (!fileType) {
                throw new Error('Type de fichier non supporté. Uniquement image ou vidéo autorisée.');
            }

            const story = await this.prisma.story.create({
                data: {
                    ...data,
                    tailleurId: tailleurId,
                    expiration: new Date(Date.now() + 24 * 60 * 60 * 1000),
                    fichier: {
                        create: {
                            url: uploadResult.secure_url,
                            type: fileType,
                        },
                    },
                },
            });

            return story;
        } catch (err) {
            console.error('Erreur lors de la création de la story:', err);
            throw new Error('Erreur lors de la création de la story');
        }
    }

    // Récupère une story par son ID
    async getStoryById(storyId: number): Promise<Story | null> {
        try {
            return await this.prisma.story.findUnique({
                where: { id: storyId },
                include: {
                    fichier: true, // Inclure le fichier associé
                },
            });
        } catch (err) {
            console.error('Erreur lors de la récupération de la story:', err);
            throw new Error('Erreur lors de la récupération de la story');
        }
    }

    // Récupère toutes les stories
    async getAllStories(): Promise<Story[]> {
        try {
            return await this.prisma.story.findMany({
                include: {
                    fichier: true,
                },
            });
        } catch (err) {
            console.error('Erreur lors de la récupération des stories:', err);
            throw new Error('Erreur lors de la récupération des stories');
        }
    }

    // Supprime une story par son ID
    async deleteStory(storyId: number): Promise<Story> {
        try {
            return await this.prisma.story.delete({
                where: { id: storyId },
            });
        } catch (err) {
            console.error('Erreur lors de la suppression de la story:', err);
            throw new Error('Erreur lors de la suppression de la story');
        }
    }

    // Supprime automatiquement les stories qui ont expiré
    async deleteExpiredStories(): Promise<void> {
        try {
            const now = new Date();
            await this.prisma.story.deleteMany({
                where: {
                    expiration: {
                        lte: now,
                    },
                },
            });

            console.log('Stories expirées supprimées avec succès');
        } catch (err) {
            console.error('Erreur lors de la suppression des stories expirées:', err);
            throw new Error('Erreur lors de la suppression des stories expirées');
        }
    }

    // Méthode pour déterminer le type de fichier
    private getFileType(url: string): 'IMAGE' | 'VIDEO' | null {
        const imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
        const videoExtensions = ['mp4', 'mov', 'avi', 'wmv'];

        const extension = url.split('.').pop()?.toLowerCase();
        if (imageExtensions.includes(extension!)) return 'IMAGE';
        if (videoExtensions.includes(extension!)) return 'VIDEO';
        return null;
    }
}
