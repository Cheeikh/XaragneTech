import { Router } from 'express';
import postInteractionController from '../controllers/PostInteractionController.js';
import { verify } from '../middlewares/AuthMiddleware.js';

const router = Router();

router.post('/posts/:id/views', verify, postInteractionController.incrementViews);
router.post('/posts/:id/shares', verify, postInteractionController.incrementShares);
router.post('/posts/:id/likes', verify, postInteractionController.addLike);
router.post('/posts/:id/dislikes', verify, postInteractionController.addDislike);
router.post('/posts/:id/downloads', verify, postInteractionController.incrementDownloads);

export default router;
