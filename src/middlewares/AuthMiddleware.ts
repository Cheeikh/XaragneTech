// src/middleware/AuthMiddleware.ts
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export const verify = (req: Request, res: Response, next: NextFunction) => {
    const token = req.headers['authorization']?.split(' ')[1]; // "Bearer TOKEN_HERE"

    if (!token) {
        return res.status(401).json({ message: 'Aucun token fourni.' });
    }

    jwt.verify(token, process.env.TOKEN_SECRET || "your_default_secret", (err, decoded) => {
        if (err) {
            return res.status(401).json({ message: 'Token non valide.' });
        }

        // Typage du req pour éviter les erreurs TypeScript
        (req as any).user = decoded; // Ajoutez le payload décodé (incluant l'id et le role) à la requête
        next();
    });
};
