import jwt from 'jsonwebtoken';

export const generateToken = (userId: number, role: string): string => {
    // Génère un token JWT avec le payload contenant l'id et le rôle de l'utilisateur
    return jwt.sign(
        { id: userId, role: role },
        process.env.TOKEN_SECRET || "your_default_secret", // Utilise la clé secrète de l'environnement ou une valeur par défaut
        { expiresIn: '7d' } // Le token expire après 7 jours
    );
};

export const verifyToken = (token: string) => {
    try {
        // Vérifie le token JWT en utilisant la clé secrète
        return jwt.verify(token, process.env.TOKEN_SECRET || "your_default_secret"); // Retourne le payload décodé (contenant id et role)
    } catch (err) {
        // Si la vérification échoue, une erreur est levée
        throw new Error('Invalid token');
    }
};
