import { PrismaClient, Signalement, SignalementMotif } from '@prisma/client';
import prisma from '../config/prisma.js';

export class SignalementService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma; // Utilisation de l'instance partagée
    }

    // Créer un signalement pour un utilisateur
    async createSignalement(utilisateurSignaleId: number, motif: SignalementMotif, description?: string): Promise<Signalement> {
        try {
            // Création du signalement
            const newSignalement = await this.prisma.signalement.create({
                data: {
                    utilisateurSignaleId: utilisateurSignaleId,
                    motif: motif, // Utilisez la variable motif ici
                    description: description,
                },
            });

            return newSignalement;
        } catch (err) {
            console.error('Erreur lors de la création du signalement:', err);
            throw new Error('Erreur lors de la création du signalement');
        }
    }

    // Récupérer les signalements pour un utilisateur spécifique
    async getSignalementsByUtilisateur(utilisateurSignaleId: number): Promise<Signalement[]> {
        try {
            const signalements = await this.prisma.signalement.findMany({
                where: { utilisateurSignaleId: utilisateurSignaleId },
                orderBy: { createdAt: 'desc' }, // Optionnel: trier par date
            });

            if (!signalements) {
                throw new Error('Aucun signalement trouvé pour cet utilisateur');
            }

            return signalements;
        } catch (err) {
            console.error('Erreur lors de la récupération des signalements:', err);
            throw new Error('Erreur lors de la récupération des signalements');
        }
    }

    // Récupérer tous les signalements
    async getAllSignalements(): Promise<Signalement[]> {
        try {
            const signalements = await this.prisma.signalement.findMany({
                orderBy: { createdAt: 'desc' }, // Optionnel: trier par date
            });

            return signalements;
        } catch (err) {
            console.error('Erreur lors de la récupération de tous les signalements:', err);
            throw new Error('Erreur lors de la récupération de tous les signalements');
        }
    }
}
