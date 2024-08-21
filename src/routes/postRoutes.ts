import { Router } from 'express';
import postController from '../controllers/PostController.js';
import { verify } from '../middlewares/AuthMiddleware.js';
import multer from 'multer';

const upload = multer(); // Initialiser Multer pour la gestion des fichiers
const router = Router();

router.post('/add-post', verify, upload.array('fichiers'), postController.createPost);
router.get('/post/:id', verify, postController.getPostById);
router.get('/all', verify, postController.getAllPosts);
router.put('/post/:id', verify, upload.array('fichiers'), postController.updatePost);
router.delete('/post/:id', verify, postController.deletePost);

export default router;
