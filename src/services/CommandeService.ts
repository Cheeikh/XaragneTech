import { PrismaClient, Commande, CommandeStatus } from '@prisma/client';
import prisma from '../config/prisma.js';

export class CommandeService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;
    }

    async createCommande(data: {
      clientId: number;
      tailleurId: number;
      serviceId: number;
      quantite: number;
      statut: CommandeStatus;
    }): Promise<Commande> {
        try {
            const service = await this.prisma.service.findUnique({
                where: { id: data.serviceId },
            });

            if (!service) {
                throw new Error('Service non trouvé');
            }

            const total = service.prixBase * data.quantite;

            const newCommande = await this.prisma.commande.create({
                data: {
                    clientId: data.clientId,
                    tailleurId: data.tailleurId,
                    serviceId: data.serviceId,
                    quantite: data.quantite,
                    total,
                    statut: data.statut,
                },
            });

            return newCommande;
        } catch (error) {
            console.error('Erreur lors de la création de la commande:', error);
            throw error;
        }
    }

    async getCommandeById(id: number): Promise<Commande | null> {
        try {
            return await this.prisma.commande.findUnique({
                where: { id },
            });
        } catch (error) {
            console.error('Erreur lors de la récupération de la commande:', error);
            throw error;
        }
    }
  
    async getAllCommandes(): Promise<Commande[]> {
        try {
            return await this.prisma.commande.findMany();
        } catch (error) {
            console.error('Erreur lors de la récupération des commandes:', error);
            throw error;
        }
    }

    async updateCommande(id: number, data: Partial<Omit<Commande, 'id' | 'createdAt' | 'updatedAt'>>): Promise<Commande> {
        try {
            const commande = await this.prisma.commande.findUnique({
                where: { id },
            });

            if (!commande) {
                throw new Error('Commande non trouvée');
            }

            if ((commande.statut === 'EN_COURS' && data.statut === 'EN_ATTENTE') ||
                (commande.statut === 'TERMINER' && (data.statut === 'EN_ATTENTE' || data.statut === 'EN_COURS'))) {
                throw new Error('Modification de l\'état de la commande non autorisée');
            }

            const updatedCommande = await this.prisma.commande.update({
                where: { id },
                data: data as Partial<Commande>,
            });

            return updatedCommande;
        } catch (error) {
            console.error('Erreur lors de la mise à jour de la commande:', error);
            throw error;
        }
    }

    async deleteCommande(id: number): Promise<Commande> {
        try {
            return await this.prisma.commande.delete({
                where: { id },
            });
        } catch (error) {
            console.error('Erreur lors de la suppression de la commande:', error);
            throw error;
        }
    }
}