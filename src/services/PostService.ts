//@ts-ignore
import { PrismaClient, Post, File } from '@prisma/client';
import cloudinary from '../config/cloudinary.js';
import prisma from '../config/prisma.js';

export class PostService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;
    }

    // Création d'un post pour un tailleur
    async createPost(data: any, files: Express.Multer.File[], tailleurId: number): Promise<Post> {
        try {
            // Création du post dans la base de données
            const post = await this.prisma.post.create({
                data: {
                    ...data,
                    tailleurId: tailleurId,
                },
            });

            // Gestion des fichiers (images/vidéos) si fournis
            if (files && files.length > 0) {
                await this.uploadAndLinkFiles(post.id, files);
            }

            return post;
        } catch (err) {
            console.error('Erreur lors de la création du post:', err);
            throw new Error('Erreur lors de la création du post');
        }
    }

    // Récupération d'un post par son ID
    async getPostById(id: number): Promise<Post | null> {
        try {
            const post = await this.prisma.post.findUnique({
                where: { id },
                include: { fichiers: true },
            });

            if (!post) {
                throw new Error('Post non trouvé');
            }

            return post;
        } catch (err) {
            console.error('Erreur lors de la récupération du post:', err);
            throw new Error('Erreur lors de la récupération du post');
        }
    }

    // Récupération de tous les posts
    async getAllPosts(): Promise<Post[]> {
        try {
            return await this.prisma.post.findMany({
                include: { fichiers: true }, // Inclure les fichiers associés
            });
        } catch (err) {
            console.error('Erreur lors de la récupération des posts:', err);
            throw new Error('Erreur lors de la récupération des posts');
        }
    }

    // Mise à jour d'un post existant
    async updatePost(id: number, data: any, files: Express.Multer.File[]): Promise<Post> {
        try {
            const post = await this.prisma.post.update({
                where: { id },
                data: {
                    ...data,
                },
            });

            // Si de nouveaux fichiers sont fournis, les télécharger et les lier au post
            if (files && files.length > 0) {
                await this.uploadAndLinkFiles(post.id, files);
            }

            return post;
        } catch (err) {
            console.error('Erreur lors de la mise à jour du post:', err);
            throw new Error('Erreur lors de la mise à jour du post');
        }
    }

    // Suppression d'un post
    async deletePost(id: number): Promise<Post> {
        try {
            // Supprimer les fichiers associés au post
            await this.prisma.file.deleteMany({
                where: { postId: id },
            });

            return this.prisma.post.delete({
                where: { id },
            });
        } catch (err) {
            console.error('Erreur lors de la suppression du post:', err);
            throw new Error('Erreur lors de la suppression du post');
        }
    }

    // Méthode privée pour gérer le téléchargement et l'association des fichiers avec le post
    private async uploadAndLinkFiles(postId: number, files: Express.Multer.File[]): Promise<void> {
        const fileUrls = await Promise.all(files.map(async (file) => {
            try {
                const result = await new Promise<any>((resolve, reject) => {
                    const uploadStream = cloudinary.uploader.upload_stream({ folder: 'post_files' }, (error, result) => {
                        if (error) reject(error);
                        resolve(result);
                    });
                    uploadStream.end(file.buffer);
                });
                return result.secure_url;
            } catch (uploadError) {
                console.error('Erreur lors du téléchargement du fichier:', uploadError);
                throw new Error('Erreur lors du téléchargement du fichier');
            }
        }));

        await this.prisma.file.createMany({
            data: fileUrls.map(url => ({
                postId,
                url,
                type: this.getFileType(url),
            })),
        });
    }

    // Méthode pour déterminer le type de fichier (IMAGE ou VIDEO) basé sur l'URL
    private getFileType(url: string): 'IMAGE' | 'VIDEO' {
        const imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
        const videoExtensions = ['mp4', 'mov', 'avi', 'wmv'];

        const extension = url.split('.').pop()?.toLowerCase();
        if (imageExtensions.includes(extension!)) return 'IMAGE';
        if (videoExtensions.includes(extension!)) return 'VIDEO';
        throw new Error('Type de fichier non supporté');
    }
}
