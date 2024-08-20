import { Request, Response } from 'express';
import { BloquerService } from '../services/BloquerService.js';
import { sendResponse, sendErrorResponse } from '../utils/response.js';
import { verify } from '../middlewares/AuthMiddleware.js';

class BloquerController {
    private bloquerService: BloquerService;

    constructor(bloquerService: BloquerService) {
        this.bloquerService = bloquerService;
    }

    blockUser = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { targetUserId } = req.body;

                // Vérifier si l'utilisateur a déjà bloqué cette personne
                const isAlreadyBlocked = await this.bloquerService.isUserBlocked(userId, targetUserId);
                if (isAlreadyBlocked) {
                    sendErrorResponse(res, 400, 'Cet utilisateur a déjà été bloqué.');
                    return;
                }

                const blockedUser = await this.bloquerService.blockUser(userId, targetUserId);
                sendResponse(res, 201, { message: 'Utilisateur bloqué avec succès', blockedUser });
            } catch (err: any) {
                console.error('Erreur lors du blocage de l\'utilisateur:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];
    unblockUser = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { targetUserId } = req.body;

                await this.bloquerService.unblockUser(userId, targetUserId);
                sendResponse(res, 200, { message: 'Utilisateur débloqué avec succès' });
            } catch (err: any) {
                console.error('Erreur lors du déblocage de l\'utilisateur:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    getBlockedUsers = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;

                const blockedUsers = await this.bloquerService.getBlockedUsers(userId);
                sendResponse(res, 200, { blockedUsers });
            } catch (err: any) {
                console.error('Erreur lors de la récupération des utilisateurs bloqués:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    isUserBlocked = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { targetUserId } = req.params;
    
                const isBlocked = await this.bloquerService.isUserBlocked(userId, parseInt(targetUserId));
    
                if (isBlocked) {
                    sendResponse(res, 200, { message: 'L\'utilisateur est actuellement bloqué.' });
                } else {
                    sendResponse(res, 200, { message: 'L\'utilisateur n\'est pas bloqué.' });
                }
            } catch (err: any) {
                console.error('Erreur lors de la vérification du statut de blocage:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];
    
}

// Création de l'instance du service
const bloquerService = new BloquerService();

// Export du contrôleur avec les dépendances correctement injectées
export default new BloquerController(bloquerService);