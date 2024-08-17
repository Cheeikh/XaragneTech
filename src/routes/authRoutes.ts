import { Router } from 'express';
import AuthController from '../controllers/AuthController.js';
import multer from 'multer';

const upload = multer(); // Pas besoin de spécifier un dossier si on ne stocke pas localement

const authRoutes = Router();

authRoutes.post('/register', upload.single('photo'), AuthController.register);
authRoutes.post('/login', AuthController.login);

export default authRoutes;
