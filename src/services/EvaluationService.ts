import { PrismaClient } from '@prisma/client';

export class EvaluationService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = new PrismaClient();
    }

    async createEvaluation(data: { utilisateurId: number, note: number, commentaire?: string }) {
        // Validation de la note
        if (data.note < 1 || data.note > 5) {
            throw new Error('La note doit être comprise entre 1 et 5.');
        }

        return this.prisma.evaluation.create({
            data: {
                utilisateurId: data.utilisateurId,
                note: data.note,
                commentaire: data.commentaire,
            },
        });
    }


    async getEvaluationByUserId(userId: number) {
        return this.prisma.evaluation.findUnique({
            where: {
                utilisateurId: userId,
            },
        });
    }

    async updateEvaluation(evaluationId: number, data: { note: number, commentaire?: string }) {
        // Validation de la note
        if (data.note < 1 || data.note > 5) {
            throw new Error('La note doit être comprise entre 1 et 5.');
        }

        return this.prisma.evaluation.update({
            where: { id: evaluationId },
            data: {
                note: data.note,
                commentaire: data.commentaire,
            },
        });
    }
    async getEvaluationsByUser(userId: number) {
        return this.prisma.evaluation.findMany({
            where: {
                utilisateurId: userId,
            },
        });
    }

    async getEvaluationById(evaluationId: number) {
        return this.prisma.evaluation.findUnique({
            where: {
                id: evaluationId,
            },
        });
    }

    async deleteEvaluation(evaluationId: number) {
        return this.prisma.evaluation.delete({
            where: {
                id: evaluationId,
            },
        });
    }
}
