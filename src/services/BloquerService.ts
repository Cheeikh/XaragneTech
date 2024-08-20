import { PrismaClient } from '@prisma/client';

export class BloquerService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = new PrismaClient();
    }

    async blockUser(userId: number, targetUserId: number): Promise<any> {
        try {
            // Vérifier si l'utilisateur est déjà bloqué
            const existingBlock = await this.prisma.bloquer.findFirst({
                where: {
                    bloqueurId: userId,
                    bloqueId: targetUserId,
                },
            });

            if (existingBlock) {
                throw new Error('Utilisateur déjà bloqué');
            }

            // Bloquer l'utilisateur
            const blockedUser = await this.prisma.bloquer.create({
                data: {
                    bloqueurId: userId,
                    bloqueId: targetUserId,
                },
            });

            return blockedUser;
        } catch (error) {
            console.error('Erreur lors du blocage de l\'utilisateur:', error);
            throw error;
        }
    }

    async unblockUser(userId: number, targetUserId: number): Promise<void> {
        try {
            // Débloquer l'utilisateur
            await this.prisma.bloquer.deleteMany({
                where: {
                    bloqueurId: userId,
                    bloqueId: targetUserId,
                },
            });
        } catch (error) {
            console.error('Erreur lors du déblocage de l\'utilisateur:', error);
            throw error;
        }
    }

    async getBlockedUsers(userId: number): Promise<any[]> {
        try {
            // Récupérer la liste des utilisateurs bloqués
            const blockedUsers = await this.prisma.bloquer.findMany({
                where: {
                    bloqueurId: userId,
                },
                include: {
                    bloque: true, // Inclure les informations de l'utilisateur bloqué
                },
            });

            return blockedUsers;
        } catch (error) {
            console.error('Erreur lors de la récupération des utilisateurs bloqués:', error);
            throw error;
        }
    }

    async isUserBlocked(userId: number, targetUserId: number): Promise<boolean> {
        try {
            // Vérifier si l'utilisateur cible est bloqué
            const blocked = await this.prisma.bloquer.findFirst({
                where: {
                    bloqueurId: userId,
                    bloqueId: targetUserId,
                },
            });

            return !!blocked;
        } catch (error) {
            console.error('Erreur lors de la vérification du statut de blocage:', error);
            throw error;
        }
    }
}