import { Router } from 'express';
import ServiceController from '../controllers/ServiceController.js';
import { verify } from '../middlewares/AuthMiddleware.js';
import multer from 'multer';

const upload = multer(); // Initialize multer for handling files

const router = Router();

// Créer un nouveau service
router.post('/create-service', verify, upload.array('images'), ServiceController.createService);

// Mettre à jour un service existant
router.put('/update-service/:id', verify, upload.array('images'), ServiceController.updateService);

// Récupérer tous les services
router.get('/list-services', ServiceController.getAllServices);

// Récupérer un service spécifique par ID
router.get('/view-service/:id', ServiceController.getServiceById);

// Supprimer un service par ID
router.delete('/delete-service/:id', verify, ServiceController.deleteService);

export default router;
