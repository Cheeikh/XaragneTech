import { PrismaClient, Tailleur, Client } from '@prisma/client';
import prisma from '../config/prisma.js';

export class FollowService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma; // Utilisation de l'instance partagée
    }

    // Permet à un client de suivre un tailleur
    async followTailleur(clientId: number, tailleurId: number): Promise<Client> {
        try {
            // Vérifiez si le client suit déjà le tailleur
            
    
            // Ajoutez le tailleur à la liste des "following" du client
            await this.prisma.clientTailleurFollowing.create({
                data: {
                    clientId: clientId,
                    tailleurId: tailleurId,
                },
            });
    
            const client = await this.prisma.client.findUnique({
                where: { utilisateurId: clientId },
                include: {
                    following: {
                        include: { tailleur: true },
                    },
                },
            });
    
            if (!client) {
                throw new Error('Client non trouvé');
            }
    
            return client;
        } catch (err) {
            console.error('Erreur lors du suivi du tailleur:', err);
            throw new Error('Erreur lors du suivi du tailleur');
        }
    }
    
    // Permet à un client de se désabonner d'un tailleur
    async unfollowTailleur(clientId: number, tailleurId: number): Promise<Client> {
        try {
            // Supprimez le tailleur de la liste des "following" du client
            await this.prisma.clientTailleurFollowing.deleteMany({
                where: {
                    clientId: clientId,
                    tailleurId: tailleurId,
                },
            });

            const client = await this.prisma.client.findUnique({
                where: { utilisateurId: clientId },
                include: {
                    following: {
                        include: { tailleur: true },
                    },
                },
            });

            if (!client) {
                throw new Error('Client non trouvé');
            }

            return client;
        } catch (err) {
            console.error('Erreur lors du désabonnement du tailleur:', err);
            throw new Error('Erreur lors du désabonnement du tailleur');
        }
    }

    // Permet à un tailleur de suivre un autre tailleur (ou à un utilisateur de suivre un autre utilisateur en général)
    async followTailleurGeneric(followerId: number, followingId: number): Promise<Tailleur> {
        try {
            // Vérifiez si le tailleur suit déjà un autre tailleur
            const existingFollow = await this.prisma.tailleurFollowing.findFirst({
                where: {
                    followerId: followerId,
                    followingId: followingId,
                },
            });

            if (existingFollow) {
                throw new Error('Vous suivez déjà ce tailleur');
            }

            // Ajoutez le tailleur à la liste des "following" du tailleur
            await this.prisma.tailleurFollowing.create({
                data: {
                    followerId: followerId,
                    followingId: followingId,
                },
            });

            const tailleur = await this.prisma.tailleur.findUnique({
                where: { utilisateurId: followerId },
                include: {
                    following: {
                        include: { following: true },
                    },
                },
            });

            if (!tailleur) {
                throw new Error('Tailleur non trouvé');
            }

            return tailleur;
        } catch (err) {
            console.error('Erreur lors du suivi du tailleur:', err);
            throw new Error('Erreur lors du suivi du tailleur');
        }
    }

    // Permet à un tailleur de se désabonner d'un autre tailleur (ou à un utilisateur de se désabonner d'un autre utilisateur en général)
    async unfollowTailleurGeneric(followerId: number, followingId: number): Promise<Tailleur> {
        try {
            // Supprimez le tailleur de la liste des "following" du tailleur
            await this.prisma.tailleurFollowing.deleteMany({
                where: {
                    followerId: followerId,
                    followingId: followingId,
                },
            });

            const tailleur = await this.prisma.tailleur.findUnique({
                where: { utilisateurId: followerId },
                include: {
                    following: {
                        include: { following: true },
                    },
                },
            });

            if (!tailleur) {
                throw new Error('Tailleur non trouvé');
            }

            return tailleur;
        } catch (err) {
            console.error('Erreur lors du désabonnement du tailleur:', err);
            throw new Error('Erreur lors du désabonnement du tailleur');
        }
    }

    // Récupérer la liste des tailleurs suivis par un client
    async getFollowedTailleurs(clientId: number): Promise<Tailleur[]> {
        try {
            const client = await this.prisma.client.findUnique({
                where: { utilisateurId: clientId },
                include: {
                    following: {
                        include: {
                            tailleur: true, // Inclure les informations des tailleurs suivis
                        },
                    },
                },
            });

            if (!client) {
                throw new Error('Client non trouvé');
            }

            return client.following.map(follow => follow.tailleur);
        } catch (err) {
            console.error('Erreur lors de la récupération des tailleurs suivis:', err);
            throw new Error('Erreur lors de la récupération des tailleurs suivis');
        }
    }

    // Récupérer la liste des clients qui suivent un tailleur
    async getFollowers(tailleurId: number): Promise<Client[]> {
        try {
            const tailleur = await this.prisma.tailleur.findUnique({
                where: { utilisateurId: tailleurId },
                include: {
                    clientFollowers: {
                        include: {
                            client: true, // Inclure les informations des clients suiveurs
                        },
                    },
                },
            });

            if (!tailleur) {
                throw new Error('Tailleur non trouvé');
            }

            return tailleur.clientFollowers.map(follow => follow.client);
        } catch (err) {
            console.error('Erreur lors de la récupération des clients suiveurs:', err);
            throw new Error('Erreur lors de la récupération des clients suiveurs');
        }
    }
}
