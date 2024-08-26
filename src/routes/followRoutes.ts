import { Router } from 'express';
import FollowController from '../controllers/FollowController.js';
import { verify } from '../middlewares/AuthMiddleware.js';


const router = Router();

// Suivre un tailleur (par un client)
router.post('/follow/tailleur/:tailleurId', verify, FollowController.followTailleur);

// Se désabonner d'un tailleur (par un client)
router.delete('/unfollow/tailleur/:tailleurId', verify, FollowController.unfollowTailleur);

// Suivre un tailleur (générique pour tailleurs)
router.post('/tailleur/follow/:followingId', verify, FollowController.followTailleurGeneric);

// Se désabonner d'un autre tailleur (générique pour tailleurs)
router.delete('/tailleur/unfollow/:followingId', verify, FollowController.unfollowTailleurGeneric);

// Récupérer les tailleurs suivis par un client
router.get('/client/following', verify, FollowController.getFollowedTailleurs);

// Récupérer les clients qui suivent un tailleur
router.get('/tailleur/followers', verify, FollowController.getFollowers);

export default router;
