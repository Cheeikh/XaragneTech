import { Request, Response } from "express";
import { sendResponse } from '../utils/response.js';
import { PostValidator } from '../validator/PostValidator.js';
import { PostService } from '../services/PostService.js';
import { z } from 'zod';

export class PostController {
    private postService: PostService;
    private postValidator: PostValidator;

    constructor(postService: PostService, postValidator: PostValidator) {
        this.postService = postService;
        this.postValidator = postValidator;
    }

    // Créer un nouveau post
    createPost = async (req: Request, res: Response): Promise<void> => {
        try {
            // Valider les données du post
            const { data, error } = this.postValidator.validate(req.body);
            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { error: zodError.errors });
                return;
            }

            const files = req.files as Express.Multer.File[];
            const tailleurId = req.user.id; // Récupérer l'ID du tailleur depuis le token
            const post = await this.postService.createPost(data, files, tailleurId);
            sendResponse(res, 201, post);
        } catch (err: any) {
            console.error('Erreur lors de la création du post:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Récupérer un post par son ID
    getPostById = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const post = await this.postService.getPostById(postId);

            if (!post) {
                sendResponse(res, 404, { message: "Post non trouvé" });
                return;
            }

            sendResponse(res, 200, post);
        } catch (err: any) {
            console.error('Erreur lors de la récupération du post:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Récupérer tous les posts
    getAllPosts = async (req: Request, res: Response): Promise<void> => {
        try {
            const posts = await this.postService.getAllPosts();
            sendResponse(res, 200, posts);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des posts:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Mettre à jour un post existant
    updatePost = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            // Valider les données du post
            const { data, error } = this.postValidator.validate(req.body);
            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { error: zodError.errors });
                return;
            }

            const files = req.files as Express.Multer.File[];
            const updatedPost = await this.postService.updatePost(postId, data, files);
            sendResponse(res, 200, updatedPost);
        } catch (err: any) {
            console.error('Erreur lors de la mise à jour du post:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    // Supprimer un post
    deletePost = async (req: Request, res: Response): Promise<void> => {
        try {
            const postId = parseInt(req.params.id, 10);

            if (isNaN(postId)) {
                sendResponse(res, 400, { message: "ID de post invalide" });
                return;
            }

            const deletedPost = await this.postService.deletePost(postId);
            sendResponse(res, 200, { message: "Post supprimé avec succès", data: deletedPost });
        } catch (err: any) {
            console.error('Erreur lors de la suppression du post:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };
}

// Initialisation des services et du contrôleur
const postService = new PostService();
const postValidator = new PostValidator();
const postController = new PostController(postService, postValidator);

export default postController;
