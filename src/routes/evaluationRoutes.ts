import { Router } from 'express';
import EvaluationController from '../controllers/EvaluationController.js';

const router = Router();

router.post('/tailleur', EvaluationController.createEvaluation);
router.get('/evaluations', EvaluationController.getEvaluationsByUser);
router.get('/evaluations/:evaluationId', EvaluationController.getEvaluationById);
router.delete('/evaluations/:evaluationId', EvaluationController.deleteEvaluation);

export default router;
