import { Request, Response } from 'express';
import { CommandeService } from '../services/CommandeService.js';
import { sendResponse } from '../utils/response.js';
import { CommandeValidator } from '../validator/CommandeValidator.js';
import { z } from 'zod';
import { Commande, CommandeStatus } from '@prisma/client';

export class CommandeController {
    private commandeService: CommandeService;
    private commandeValidator: CommandeValidator;

    constructor(commandeService: CommandeService, commandeValidator: CommandeValidator) {
        this.commandeService = commandeService;
        this.commandeValidator = commandeValidator;
    }

    createCommande = async (req: Request, res: Response): Promise<void> => {
        try {
            const { data, error } = this.commandeValidator.validate(req.body);
            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { error: zodError.errors });
                return;
            }

            if (typeof data === 'string') {
                throw new Error('Invalid data format');
            }

            const clientId = (req.user as any).id;

            if (!data.tailleurId) {
                throw new Error('TailleurId is required');
            }

            const commandeData = {
                clientId,
                tailleurId: data.tailleurId,
                serviceId: data.serviceId,
                quantite: data.quantite,
                statut: data.statut as CommandeStatus
            };

            const commande = await this.commandeService.createCommande(commandeData);
            sendResponse(res, 201, commande);
        } catch (err: any) {
            console.error('Erreur lors de la création de la commande:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    getCommandeById = async (req: Request, res: Response): Promise<void> => {
        try {
            const commande = await this.commandeService.getCommandeById(Number(req.params.id));
            if (!commande) {
                sendResponse(res, 404, { message: 'Commande non trouvée' });
                return;
            }
            sendResponse(res, 200, commande);
        } catch (err: any) {
            console.error('Erreur lors de la récupération de la commande:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    getAllCommandes = async (_req: Request, res: Response): Promise<void> => {
        try {
            const commandes = await this.commandeService.getAllCommandes();
            sendResponse(res, 200, commandes);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des commandes:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    updateCommande = async (req: Request, res: Response): Promise<void> => {
        try {
            const { data, error } = this.commandeValidator.validate(req.body);
            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { error: zodError.errors });
                return;
            }

            const commande = await this.commandeService.updateCommande(Number(req.params.id), data as Partial<Omit<Commande, 'id' | 'createdAt' | 'updatedAt'>>);
            sendResponse(res, 200, commande);
        } catch (err: any) {
            console.error('Erreur lors de la mise à jour de la commande:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    deleteCommande = async (req: Request, res: Response): Promise<void> => {
        try {
            const commande = await this.commandeService.deleteCommande(Number(req.params.id));
            sendResponse(res, 200, commande);
        } catch (err: any) {
            console.error('Erreur lors de la suppression de la commande:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };
}

// Création de l'instance du service et du contrôleur
const commandeService = new CommandeService();
const commandeValidator = new CommandeValidator();
export default new CommandeController(commandeService, commandeValidator);
