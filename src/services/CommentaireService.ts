import { PrismaClient, Commentaire } from '@prisma/client';
import cloudinary from '../config/cloudinary.js';
import prisma from '../config/prisma.js';
export class CommentaireService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;
    }

    // Créer un nouveau commentaire
    async createComment(postId: number, userId: number, contenu: string): Promise<Commentaire> {
        return this.prisma.commentaire.create({
            data: {
                contenu,
                postId,
                utilisateurId: userId,
            },
        });
    }

    // Récupérer tous les commentaires d'un post
    async getCommentsByPostId(postId: number): Promise<Commentaire[]> {
        return this.prisma.commentaire.findMany({
            where: { postId },
            include: {
                utilisateur: true, // Inclure les informations de l'utilisateur ayant fait le commentaire
            },
            orderBy: {
                createdAt: 'desc', // Trier par date de création, du plus récent au plus ancien
            },
        });
    }

    // Récupérer un commentaire par son ID
    async getCommentById(commentId: number): Promise<Commentaire | null> {
        return this.prisma.commentaire.findUnique({
            where: { id: commentId },
            include: {
                utilisateur: true,
                post: true, // Inclure les informations du post lié
            },
        });
    }

    // Mettre à jour un commentaire
    async updateComment(commentId: number, contenu: string): Promise<Commentaire> {
        return this.prisma.commentaire.update({
            where: { id: commentId },
            data: { contenu },
        });
    }

    // Supprimer un commentaire
    async deleteComment(commentId: number): Promise<Commentaire> {
        return this.prisma.commentaire.delete({
            where: { id: commentId },
        });
    }
}
