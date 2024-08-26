import { Request, Response } from 'express';
import { SignalementService } from '../services/SignalementService.js';
import { sendResponse } from '../utils/response.js';

export class SignalementController{
    private signalementService: SignalementService;
    constructor(signalementService: SignalementService) {
        this.signalementService = signalementService;
    }
    createSignalement = async (req: Request, res: Response): Promise<void> => {
        try {
            const { utilisateurSignaleId, motif, description } = req.body;
            const signalement = await this.signalementService.createSignalement(utilisateurSignaleId, motif, description);
            sendResponse(res, 201, signalement);
        } catch (err: any) {
            console.error('Erreur lors de la création du signalement:', err);
            sendResponse(res, 500, { message: 'Erreur lors de la création du signalement', error: err.message });
        }
    };
    getSignalementsByUtilisateur = async (req: Request, res: Response): Promise<void> => {
        try {
            const utilisateurSignaleId = parseInt(req.params.id);
            const signalements = await this.signalementService.getSignalementsByUtilisateur(utilisateurSignaleId);
            sendResponse(res, 200, signalements);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des signalements pour l\'utilisateur:', err);
            sendResponse(res, 500, { message: 'Erreur lors de la récupération des signalements pour l\'utilisateur', error: err.message });
        }
    };
    getAllSignalements = async (req: Request, res: Response): Promise<void> => {
        try {
            const signalements = await this.signalementService.getAllSignalements();
            sendResponse(res, 200, signalements);
        } catch (err: any) {
            console.error('Erreur lors de la récupération de tous les signalements:', err);
            sendResponse(res, 500, { message: 'Erreur lors de la récupération de tous les signalements', error: err.message });
        }
    };
}
  
// Création de l'instance du service et du contrôleur
const signalementService = new SignalementService();
export default new SignalementController(signalementService);