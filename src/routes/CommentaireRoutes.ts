import { Router } from 'express';
import commentaireController from '../controllers/CommentaireController.js';
import { verify } from '../middlewares/AuthMiddleware.js';

const router = Router();

router.post('/posts/:postId/commentaires', verify, commentaireController.createComment);
router.get('/posts/:postId/commentaires', commentaireController.getCommentsByPostId);
router.get('/commentaires/:id', commentaireController.getCommentById);
router.put('/commentaires/:id', verify, commentaireController.updateComment);
router.delete('/commentaires/:id', verify, commentaireController.deleteComment);

export default router;
