import { Request, Response } from "express";
import { sendResponse } from '../utils/response.js';
import { PostInteractionService } from '../services/PostInteractionService.js';


export class PostInteractionController {
    private postInteractionService: PostInteractionService;

    constructor(postInteractionService: PostInteractionService) {
        this.postInteractionService = postInteractionService;
    }

    // Incrémenter les vues d'un post
    incrementViews = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const post = await this.postInteractionService.incrementViews(postId);
            sendResponse(res, 200, post);
        } catch (err: any) {
            console.error('Erreur lors de l\'incrémentation des vues:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Incrémenter les partages d'un post
    incrementShares = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const post = await this.postInteractionService.incrementShares(postId);
            sendResponse(res, 200, post);
        } catch (err: any) {
            console.error('Erreur lors de l\'incrémentation des partages:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Ajouter un like à un post
    addLike = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const userId = req.user.id;
            const post = await this.postInteractionService.addLike(postId, userId);
            sendResponse(res, 200, post);
        } catch (err: any) {
            console.error('Erreur lors de l\'ajout du like:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Ajouter un dislike à un post
    addDislike = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const userId = req.user.id;
            const post = await this.postInteractionService.addDislike(postId, userId);
            sendResponse(res, 200, post);
        } catch (err: any) {
            console.error('Erreur lors de l\'ajout du dislike:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Incrémenter les téléchargements d'un post
    incrementDownloads = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const post = await this.postInteractionService.incrementDownloads(postId);
            sendResponse(res, 200, post);
        } catch (err: any) {
            console.error('Erreur lors de l\'incrémentation des téléchargements:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };
}

// Initialisation du service et du contrôleur
const postInteractionService = new PostInteractionService();
const postInteractionController = new PostInteractionController(postInteractionService);

export default postInteractionController;
