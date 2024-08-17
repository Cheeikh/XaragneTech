import { Request, Response } from 'express';
import { AuthService } from '../services/AuthService.js';
import { sendResponse } from '../utils/response.js';
import { UtilisateurValidator } from '../validator/UtilisateurValidator.js';
import { z } from 'zod';

class AuthController {
    private authService: AuthService;
    private utilisateurValidator: UtilisateurValidator;

    constructor(authService: AuthService, utilisateurValidator: UtilisateurValidator) {
        this.authService = authService;
        this.utilisateurValidator = utilisateurValidator;
    }

    register = async (req: Request, res: Response): Promise<void> => {
        try {
            const { data, error } = this.utilisateurValidator.validate(req.body);

            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { error: zodError.errors });
                return;
            }

            // Enregistrement de l'utilisateur
            const utilisateur = await this.authService.register(data, req.file);  // Utilisez req.file ici

            // Réponse après enregistrement
            sendResponse(res, 201, { message: 'Enregistrement réussi', utilisateur });
        } catch (err: any) {
            console.error('Erreur lors de l\'enregistrement:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    }

    login = async (req: Request, res: Response): Promise<void> => {
        try {
            const { login, motDePasse } = req.body;
            const { utilisateur, token } = await this.authService.login(login, motDePasse);
            sendResponse(res, 200, { utilisateur, token });
        } catch (err: any) {
            console.error('Erreur lors de la connexion:', err);
            sendResponse(res, 401, { message: err.message });
        }
    }
}

// Création de l'instance du service et du validateur
const authService = new AuthService();
const utilisateurValidator = new UtilisateurValidator();

// Export du contrôleur avec les dépendances correctement injectées
export default new AuthController(authService, utilisateurValidator);
