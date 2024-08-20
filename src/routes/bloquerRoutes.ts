import express from 'express';import { Router } from 'express';
import BloquerController from '../controllers/BloquerController.js';
import { verify } from '../middlewares/AuthMiddleware.js';

const router = Router();

// Route pour bloquer un utilisateur
router.post('/bloquer', verify, BloquerController.blockUser);

// Route pour débloquer un utilisateur
router.post('/debloquer', verify, BloquerController.unblockUser);

// Route pour récupérer les utilisateurs bloqués
router.get('/bloques', verify, BloquerController.getBlockedUsers);

// Route pour vérifier si un utilisateur est bloqué
router.get('/est-bloque/:targetUserId', verify, BloquerController.isUserBlocked);

export default router;