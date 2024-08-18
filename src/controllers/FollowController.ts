import { Request, Response } from 'express';
import { FollowService } from '../services/FollowService.js';
import { sendResponse } from '../utils/response.js';

export class FollowController {
    private followService: FollowService;

    constructor(followService: FollowService) {
        this.followService = followService;
    }

    // Suivre un tailleur
    followTailleur = async (req: Request, res: Response): Promise<void> => {
        try {
            const clientId = req.user.id; // ID du client depuis le token
            const { tailleurId } = req.body;

            const client = await this.followService.followTailleur(clientId, tailleurId);
            sendResponse(res, 200, client);
        } catch (err: any) {
            console.error('Erreur lors du suivi du tailleur:', err);
            sendResponse(res, 500, { message: 'Erreur lors du suivi du tailleur', error: err.message });
        }
    };

    // Se désabonner d'un tailleur
    unfollowTailleur = async (req: Request, res: Response): Promise<void> => {
        try {
            const clientId = req.user.id; // ID du client depuis le token
            const { tailleurId } = req.body;

            const client = await this.followService.unfollowTailleur(clientId, tailleurId);
            sendResponse(res, 200, client);
        } catch (err: any) {
            console.error('Erreur lors du désabonnement du tailleur:', err);
            sendResponse(res, 500, { message: 'Erreur lors du désabonnement du tailleur', error: err.message });
        }
    };

    // Suivre un autre tailleur (générique pour tailleurs)
    followTailleurGeneric = async (req: Request, res: Response): Promise<void> => {
        try {
            const followerId = req.user.id; // ID du tailleur suiveur depuis le token
            const { followingId } = req.body;

            const tailleur = await this.followService.followTailleurGeneric(followerId, followingId);
            sendResponse(res, 200, tailleur);
        } catch (err: any) {
            console.error('Erreur lors du suivi du tailleur:', err);
            sendResponse(res, 500, { message: 'Erreur lors du suivi du tailleur', error: err.message });
        }
    };

    // Se désabonner d'un autre tailleur (générique pour tailleurs)
    unfollowTailleurGeneric = async (req: Request, res: Response): Promise<void> => {
        try {
            const followerId = req.user.id; // ID du tailleur suiveur depuis le token
            const { followingId } = req.body;

            const tailleur = await this.followService.unfollowTailleurGeneric(followerId, followingId);
            sendResponse(res, 200, tailleur);
        } catch (err: any) {
            console.error('Erreur lors du désabonnement du tailleur:', err);
            sendResponse(res, 500, { message: 'Erreur lors du désabonnement du tailleur', error: err.message });
        }
    };

    // Récupérer les tailleurs suivis par un client
    getFollowedTailleurs = async (req: Request, res: Response): Promise<void> => {
        try {
            const clientId = req.user.id; // ID du client depuis le token
            const tailleurs = await this.followService.getFollowedTailleurs(clientId);
            sendResponse(res, 200, tailleurs);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des tailleurs suivis:', err);
            sendResponse(res, 500, { message: 'Erreur lors de la récupération des tailleurs suivis', error: err.message });
        }
    };

    // Récupérer les clients qui suivent un tailleur
    getFollowers = async (req: Request, res: Response): Promise<void> => {
        try {
            const tailleurId = req.user.id; // ID du tailleur depuis le token
            const clients = await this.followService.getFollowers(tailleurId);
            sendResponse(res, 200, clients);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des suiveurs:', err);
            sendResponse(res, 500, { message: 'Erreur lors de la récupération des suiveurs', error: err.message });
        }
    };
}

// Création de l'instance du service et du contrôleur
const followService = new FollowService();
export default new FollowController(followService);
