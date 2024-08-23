import { Router } from 'express';
import storyController from '../controllers/StoryController.js';
import { verify } from '../middlewares/AuthMiddleware.js';
import multer from 'multer';

const upload = multer({ limits: { fileSize: 10 * 1024 * 1024 } }); // Limite de taille de fichier à 10 MB
const router = Router();

// Route pour créer une nouvelle story
router.post('/story', verify, upload.single('fichier'), storyController.createStory);

// Route pour récupérer une story par son ID
router.get('/story/:id', verify, storyController.getStoryById);

// Route pour récupérer toutes les stories
router.get('/stories', verify, storyController.getAllStories);

// Route pour supprimer une story par son ID
router.delete('/story/:id', verify, storyController.deleteStory);

export default router;
