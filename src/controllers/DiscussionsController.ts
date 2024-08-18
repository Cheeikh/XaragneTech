import { Request, Response } from 'express';
import { DiscussionsService } from '../services/DiscussionsService.js';
import { sendResponse, sendErrorResponse } from '../utils/response.js';
import { verify } from '../middlewares/AuthMiddleware.js';

class DiscussionController {
    private discussionsService: DiscussionsService;

    constructor(discussionsService: DiscussionsService) {
        this.discussionsService = discussionsService;
    }

    createDiscussion = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { clientId } = req.body;

                if ((req as any).user.role !== 'TAILLEUR') {
                    sendErrorResponse(res, 403, 'Seuls les tailleurs peuvent créer une discussion');
                    return;
                }

                const discussion = await this.discussionsService.createDiscussion(clientId, userId);
                sendResponse(res, 201, { message: 'Discussion créée', discussion });
            } catch (err: any) {
                console.error('Erreur lors de la création de la discussion:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    getDiscussions = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const userRole = (req as any).user.role;

                let discussions;
                if (userRole === 'CLIENT') {
                    discussions = await this.discussionsService.getDiscussionsByClientId(userId);
                } else if (userRole === 'TAILLEUR') {
                    discussions = await this.discussionsService.getDiscussionsByTailleurId(userId);
                } else {
                    sendErrorResponse(res, 403, 'Rôle non autorisé');
                    return;
                }

                sendResponse(res, 200, { discussions });
            } catch (err: any) {
                console.error('Erreur lors de la récupération des discussions:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    addMessage = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { discussionId, contenu, type } = req.body;
    
                const discussion = await this.discussionsService.getDiscussionById(discussionId);
                if (!discussion) {
                    sendErrorResponse(res, 404, 'Discussion non trouvée');
                    return;
                }
    
                if (discussion.clientId !== userId && discussion.tailleurId !== userId) {
                    sendErrorResponse(res, 403, 'Non autorisé à ajouter un message à cette discussion');
                    return;
                }
    
                const message = await this.discussionsService.addMessage(discussionId, userId, contenu, type);
                sendResponse(res, 201, { message: 'Message ajouté', data: message });
            } catch (err: any) {
                console.error('Erreur lors de l\'ajout du message:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    markMessagesAsRead = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { discussionId } = req.params;

                await this.discussionsService.markMessagesAsRead(parseInt(discussionId), userId);
                sendResponse(res, 200, { message: 'Messages marqués comme lus' });
            } catch (err: any) {
                console.error('Erreur lors du marquage des messages comme lus:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    updateDiscussionStatus = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { discussionId } = req.params;
                const { status } = req.body;

                const discussion = await this.discussionsService.getDiscussionById(parseInt(discussionId));
                if (discussion?.clientId !== userId && discussion?.tailleurId !== userId) {
                    sendErrorResponse(res, 403, 'Non autorisé à modifier cette discussion');
                    return;
                }

                const updatedDiscussion = await this.discussionsService.updateDiscussionStatus(parseInt(discussionId), status);
                sendResponse(res, 200, { message: 'Statut de la discussion mis à jour', discussion: updatedDiscussion });
            } catch (err: any) {
                console.error('Erreur lors de la mise à jour du statut de la discussion:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    deleteMessage = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { messageId } = req.params;

                await this.discussionsService.deleteMessage(parseInt(messageId), userId);
                sendResponse(res, 200, { message: 'Message supprimé' });
            } catch (err: any) {
                console.error('Erreur lors de la suppression du message:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    searchInDiscussion = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { discussionId } = req.params;
                const { searchTerm } = req.query;

                const discussion = await this.discussionsService.getDiscussionById(parseInt(discussionId));
                if (discussion?.clientId !== userId && discussion?.tailleurId !== userId) {
                    sendErrorResponse(res, 403, 'Non autorisé à rechercher dans cette discussion');
                    return;
                }

                const messages = await this.discussionsService.searchInDiscussion(parseInt(discussionId), searchTerm as string);
                sendResponse(res, 200, { messages });
            } catch (err: any) {
                console.error('Erreur lors de la recherche dans la discussion:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    getDiscussionStats = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;

                const stats = await this.discussionsService.getDiscussionStats(userId);
                sendResponse(res, 200, { stats });
            } catch (err: any) {
                console.error('Erreur lors de la récupération des statistiques des discussions:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    getUnreadMessagesCount = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;

                const unreadCounts = await this.discussionsService.getUnreadMessagesCount(userId);
                sendResponse(res, 200, { unreadCounts });
            } catch (err: any) {
                console.error('Erreur lors de la récupération du nombre de messages non lus:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];

    getDiscussionById = [
        verify,
        async (req: Request, res: Response): Promise<void> => {
            try {
                const userId = (req as any).user.id;
                const { discussionId } = req.params;

                const discussion = await this.discussionsService.getDiscussionById(parseInt(discussionId));
                if (!discussion) {
                    sendErrorResponse(res, 404, 'Discussion non trouvée');
                    return;
                }

                if (discussion.clientId !== userId && discussion.tailleurId !== userId) {
                    sendErrorResponse(res, 403, 'Non autorisé à accéder à cette discussion');
                    return;
                }

                sendResponse(res, 200, { discussion });
            } catch (err: any) {
                console.error('Erreur lors de la récupération de la discussion:', err);
                sendErrorResponse(res, 500, 'Erreur serveur interne');
            }
        }
    ];
}

// Création de l'instance du service
const discussionsService = new DiscussionsService();

// Export du contrôleur avec les dépendances correctement injectées
export default new DiscussionController(discussionsService);