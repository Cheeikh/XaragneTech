import { Request, Response } from 'express';
import { sendResponse } from '../utils/response.js';
import { StoryValidator } from '../validator/StoryValidator.js';
import { StoryService } from '../services/StoryService.js';
import { z } from 'zod';

export class StoryController {
    private storyService: StoryService;
    private storyValidator: StoryValidator;

    constructor(storyService: StoryService, storyValidator: StoryValidator) {
        this.storyService = storyService;
        this.storyValidator = storyValidator;
    }

    createStory = async (req: Request, res: Response): Promise<void> => {
        try {
            const { data, error } = this.storyValidator.validate(req.body);
            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { errors: zodError.errors });
                return;
            }

            if (!req.file) {
                sendResponse(res, 400, { message: 'Aucun fichier fourni. Veuillez fournir une image ou une vidéo.' });
                return;
            }

            const file = req.file as Express.Multer.File;
            const tailleurId = req.user.id;

            const story = await this.storyService.createStory(data, file, tailleurId);
            sendResponse(res, 201, story);
        } catch (err: any) {
            console.error('Erreur lors de la création de la story:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    getStoryById = async (req: Request, res: Response): Promise<void> => {
        try {
            const storyId = parseInt(req.params.id, 10);

            if (isNaN(storyId)) {
                sendResponse(res, 400, { message: 'ID de story invalide' });
                return;
            }

            const story = await this.storyService.getStoryById(storyId);

            if (!story) {
                sendResponse(res, 404, { message: 'Story non trouvée' });
                return;
            }

            sendResponse(res, 200, story);
        } catch (err: any) {
            console.error('Erreur lors de la récupération de la story:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    getAllStories = async (_req: Request, res: Response): Promise<void> => {
        try {
            const stories = await this.storyService.getAllStories();
            sendResponse(res, 200, stories);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des stories:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    deleteStory = async (req: Request, res: Response): Promise<void> => {
        try {
            const storyId = parseInt(req.params.id, 10);

            if (isNaN(storyId)) {
                sendResponse(res, 400, { message: 'ID de story invalide' });
                return;
            }

            const deletedStory = await this.storyService.deleteStory(storyId);
            sendResponse(res, 200, { message: 'Story supprimée avec succès', data: deletedStory });
        } catch (err: any) {
            console.error('Erreur lors de la suppression de la story:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };
}

// Initialisation des services et du contrôleur
const storyService = new StoryService();
const storyValidator = new StoryValidator();
const storyController = new StoryController(storyService, storyValidator);

export default storyController;
