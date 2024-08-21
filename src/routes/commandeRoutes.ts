import { Router } from 'express';
import CommandeController from '../controllers/CommandeController.js';
import { verify } from '../middlewares/AuthMiddleware.js';

const router = Router();

router.post('/create', verify, CommandeController.createCommande);
router.get('/', verify, CommandeController.getAllCommandes);
router.get('/:id', verify, CommandeController.getCommandeById);
router.put('/:id', verify, CommandeController.updateCommande);
router.delete('/:id', verify, CommandeController.deleteCommande);

export default router;