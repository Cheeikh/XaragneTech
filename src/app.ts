import express, { Application } from 'express';
import prisma from './config/prisma.js';  // Import de l'instance partagée
import authRoutes from './routes/authRoutes.js';
import ServiceRoutes from './routes/servicesRoutes.js';
import postRoutes from "./routes/postRoutes.js"
import PostInteractionRoutes from "./routes/postInteractionRoutes.js";
import CommentaireRoutes  from "./routes/CommentaireRoutes.js";
import StoryRoutes from "./routes/storyRoutes.js";

const app: Application = express();

// Middleware pour parser les requêtes JSON
app.use(express.json());

// Définition des routes publiques pour l'authentification
app.use('/api/auth', authRoutes);
app.use('/api/services', ServiceRoutes);
app.use('/api/services', ServiceRoutes);
app.use('/api/posts', postRoutes);
app.use('/api/PostInteraction', PostInteractionRoutes);
app.use('/api/commentaire',CommentaireRoutes)
app.use('/api/stories', StoryRoutes)

// Middleware pour gérer les erreurs 404
app.use((req, res) => {
    res.status(404).send({ message: 'Resource not found' });
});

export { app, prisma };
