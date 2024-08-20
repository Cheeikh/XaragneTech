import { Router } from 'express';
import DiscussionController from '../controllers/DiscussionsController.js';
import { verify } from '../middlewares/AuthMiddleware.js';

const router = Router();

// Créer une discussion
router.post('/', verify, DiscussionController.createDiscussion);

// Récupérer les discussions du client ou du tailleur connecté
router.get('/', verify, DiscussionController.getDiscussions);

// Ajouter un message à une discussion
router.post('/:discussionId/messages', verify, DiscussionController.addMessage);

// Marquer tous les messages d'une discussion comme lus
router.put('/:discussionId/read', verify, DiscussionController.markMessagesAsRead);

// Mettre à jour le statut d'une discussion
router.put('/:discussionId/status', verify, DiscussionController.updateDiscussionStatus);

// Supprimer un message d'une discussion
router.delete('/messages/:messageId', verify, DiscussionController.deleteMessage);

// Rechercher un terme dans une discussion
router.get('/:discussionId/search', verify, DiscussionController.searchInDiscussion);

// Récupérer les statistiques des discussions
router.get('/stats', verify, DiscussionController.getDiscussionStats);

// Récupérer le nombre de messages non lus pour l'utilisateur connecté
router.get('/unread-count', verify, DiscussionController.getUnreadMessagesCount);

// Récupérer une discussion spécifique par ID
router.get('/:discussionId', verify, DiscussionController.getDiscussionById);

export default router;
