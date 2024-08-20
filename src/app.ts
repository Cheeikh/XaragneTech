import express, { Application } from 'express';
import prisma from './config/prisma.js';  // Import de l'instance partagée
import authRoutes from './routes/authRoutes.js';
import ServiceRoutes from './routes/servicesRoutes.js';
import followRoutes from './routes/followRoutes.js';
import signalementRoutes from './routes/signalementRoutes.js';
import bloquerRoutes from './routes/bloquerRoutes.js'
import evaluationRoutes from './routes/evaluationRoutes.js'
import DiscussionsRoutes from './routes/discussionsRoutes.js';

const app: Application = express();

// Middleware pour parser les requêtes JSON
app.use(express.json());

// Définition des routes publiques pour l'authentification
app.use('/api/auth', authRoutes);
app.use('/api/services', ServiceRoutes);
app.use('/api/follow', followRoutes);
app.use ("/api/signalement", signalementRoutes);
app.use('/api/bloquer', bloquerRoutes);
app.use('/api/evaluations', evaluationRoutes)
app.use ("/api/signalement", signalementRoutes)
app.use ("/api/discussions", DiscussionsRoutes)

// Middleware pour gérer les erreurs 404
app.use((req, res) => {
    res.status(404).send({ message: 'Resource not found' });
});

export { app, prisma };
