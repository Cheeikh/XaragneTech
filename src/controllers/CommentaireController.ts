import { Request, Response } from 'express';
import { sendResponse } from '../utils/response.js';
import { CommentaireService } from '../services/CommentaireService.js';

export class CommentaireController {
    private commentaireService: CommentaireService;

    constructor(commentaireService: CommentaireService) {
        this.commentaireService = commentaireService;
    }

    // Créer un nouveau commentaire
    createComment = async (req: Request, res: Response): Promise<void> => {
        try {
            const { contenu } = req.body;
            const postId = parseInt(req.params.postId, 10);
            const userId = req.user.id;

            if (!contenu || isNaN(postId)) {
                sendResponse(res, 400, { message: "Contenu ou ID de post invalide" });
                return;
            }

            const comment = await this.commentaireService.createComment(postId, userId, contenu);
            sendResponse(res, 201, comment);
        } catch (err: any) {
            console.error('Erreur lors de la création du commentaire:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Récupérer tous les commentaires d'un post
    getCommentsByPostId = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.postId, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const comments = await this.commentaireService.getCommentsByPostId(postId);
            sendResponse(res, 200, comments);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des commentaires:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Récupérer un commentaire par son ID
    getCommentById = async (req: Request, res: Response): Promise<void> => {
        try {
            const commentId = parseInt(req.params.id, 10);

            if (isNaN(commentId)) {
                sendResponse(res, 400, { message: "ID de commentaire invalide" });
                return;
            }

            const comment = await this.commentaireService.getCommentById(commentId);

            if (!comment) {
                sendResponse(res, 404, { message: "Commentaire non trouvé" });
                return;
            }

            sendResponse(res, 200, comment);
        } catch (err: any) {
            console.error('Erreur lors de la récupération du commentaire:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Mettre à jour un commentaire
    updateComment = async (req: Request, res: Response): Promise<void> => {
        try {
            const commentId = parseInt(req.params.id, 10);
            const { contenu } = req.body;

            if (!contenu || isNaN(commentId)) {
                sendResponse(res, 400, { message: "Contenu ou ID de commentaire invalide" });
                return;
            }

            const updatedComment = await this.commentaireService.updateComment(commentId, contenu);
            sendResponse(res, 200, updatedComment);
        } catch (err: any) {
            console.error('Erreur lors de la mise à jour du commentaire:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Supprimer un commentaire
    deleteComment = async (req: Request, res: Response): Promise<void> => {
        try {
            const commentId = parseInt(req.params.id, 10);

            if (isNaN(commentId)) {
                sendResponse(res, 400, { message: "ID de commentaire invalide" });
                return;
            }

            const deletedComment = await this.commentaireService.deleteComment(commentId);
            sendResponse(res, 200, { message: "Commentaire supprimé avec succès", data: deletedComment });
        } catch (err: any) {
            console.error('Erreur lors de la suppression du commentaire:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };
}

// Initialisation du service et du contrôleur
const commentaireService = new CommentaireService();
const commentaireController = new CommentaireController(commentaireService);

export default commentaireController;
