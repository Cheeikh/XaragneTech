import { Request, Response } from 'express';
import { ServiceService } from '../services/ServiceService.js';
import { sendResponse } from '../utils/response.js';
import { ServiceValidator } from '../validator/ServiceValidator.js';
import { z } from 'zod';

export class ServiceController {
    private serviceService: ServiceService;
    private serviceValidator: ServiceValidator;

    constructor(serviceService: ServiceService, serviceValidator: ServiceValidator) {
        this.serviceService = serviceService;
        this.serviceValidator = serviceValidator;
    }

    createService = async (req: Request, res: Response): Promise<void> => {
        try {
            // Valider les données du service
            const { data, error } = this.serviceValidator.validate(req.body);
            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { error: zodError.errors });
                return;
            }

            const files = req.files as Express.Multer.File[];
            const tailleurId = req.user.id; // Récupérer l'ID du tailleur depuis le token
            const service = await this.serviceService.createService(data, files, tailleurId);
            sendResponse(res, 201, service);
        } catch (err: any) {
            console.error('Erreur lors de la création du service:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    getServiceById = async (req: Request, res: Response): Promise<void> => {
        try {
            const service = await this.serviceService.getServiceById(Number(req.params.id));
            if (!service) {
                sendResponse(res, 404, { message: 'Service non trouvé' });
                return;
            }
            sendResponse(res, 200, service);
        } catch (err: any) {
            console.error('Erreur lors de la récupération du service:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    getAllServices = async (_req: Request, res: Response): Promise<void> => {
        try {
            const services = await this.serviceService.getAllServices();
            sendResponse(res, 200, services);
        } catch (err: any) {
            console.error('Erreur lors de la récupération des services:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    updateService = async (req: Request, res: Response): Promise<void> => {
        try {
            // Valider les données du service
            const { data, error } = this.serviceValidator.validate(req.body);
            if (error) {
                const zodError: z.ZodError = error as z.ZodError;
                sendResponse(res, 400, { error: zodError.errors });
                return;
            }

            const files = req.files as Express.Multer.File[];
            const service = await this.serviceService.updateService(Number(req.params.id), data, files);
            sendResponse(res, 200, service);
        } catch (err: any) {
            console.error('Erreur lors de la mise à jour du service:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };

    deleteService = async (req: Request, res: Response): Promise<void> => {
        try {
            const service = await this.serviceService.deleteService(Number(req.params.id));
            sendResponse(res, 200, service);
        } catch (err: any) {
            console.error('Erreur lors de la suppression du service:', err);
            sendResponse(res, 500, { message: 'Erreur serveur interne', error: err.message });
        }
    };
}

// Création de l'instance du service et du contrôleur
const serviceService = new ServiceService();
const serviceValidator = new ServiceValidator();
export default new ServiceController(serviceService, serviceValidator);
