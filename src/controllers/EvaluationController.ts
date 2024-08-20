import { Request, Response } from 'express';
import { EvaluationService } from '../services/EvaluationService.js';
import { sendResponse, sendErrorResponse } from '../utils/response.js';
import { verify } from '../middlewares/AuthMiddleware.js';

class EvaluationController {
    private evaluationService: EvaluationService;

    constructor(evaluationService: EvaluationService) {
        this.evaluationService = evaluationService;
    }

    // Créer une évaluation
    createEvaluation = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { note, commentaire } = req.body;
    
                // Validation de la note
                if (note < 1 || note > 5) {
                    sendErrorResponse(res, 400, 'La note doit être comprise entre 1 et 5.');
                    return;
                }
    
                const existingEvaluation = await this.evaluationService.getEvaluationByUserId(userId);
    
                let evaluation;
                if (existingEvaluation) {
                    evaluation = await this.evaluationService.updateEvaluation(existingEvaluation.id, {
                        note,
                        commentaire,
                    });
                    sendResponse(res, 200, { message: 'Évaluation mise à jour avec succès', evaluation });
                } else {
                    evaluation = await this.evaluationService.createEvaluation({
                        utilisateurId: userId,
                        note,
                        commentaire
                    });
                    sendResponse(res, 201, { message: 'Évaluation créée avec succès', evaluation });
                }
            } catch (err: any) {
                console.error('Erreur lors de la création ou de la mise à jour de l\'évaluation:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];
    
    // Obtenir toutes les évaluations pour un utilisateur
    getEvaluationsByUser = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;

                const evaluations = await this.evaluationService.getEvaluationsByUser(userId);
                sendResponse(res, 200, { evaluations });
            } catch (err: any) {
                console.error('Erreur lors de la récupération des évaluations:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    // Obtenir les détails d'une évaluation spécifique
    getEvaluationById = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const { evaluationId } = req.params;

                const evaluation = await this.evaluationService.getEvaluationById(parseInt(evaluationId));
                if (!evaluation) {
                    sendErrorResponse(res, 404, 'Évaluation non trouvée');
                    return;
                }

                sendResponse(res, 200, { evaluation });
            } catch (err: any) {
                console.error('Erreur lors de la récupération de l\'évaluation:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    // Supprimer une évaluation
    deleteEvaluation = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const { evaluationId } = req.params;

                await this.evaluationService.deleteEvaluation(parseInt(evaluationId));
                sendResponse(res, 200, { message: 'Évaluation supprimée avec succès' });
            } catch (err: any) {
                console.error('Erreur lors de la suppression de l\'évaluation:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];
}

// Création de l'instance du service
const evaluationService = new EvaluationService();

// Export du contrôleur avec les dépendances correctement injectées
export default new EvaluationController(evaluationService);
