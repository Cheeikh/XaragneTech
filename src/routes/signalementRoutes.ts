import { Router } from 'express';
import SignalementController from '../controllers/SignalementController.js';
import { verify } from '../middlewares/AuthMiddleware.js';
import multer from 'multer';

const upload = multer(); // Initialize multer for handling files

const router = Router();
// Route pour créer un signalement
router.post('/create', verify, SignalementController.createSignalement);

export default router;