// src/services/AuthService.ts
// @ts-ignore
import { PrismaClient, Utilisateur } from '@prisma/client';
import bcrypt from 'bcryptjs';
import cloudinary from '../config/cloudinary.js';
import prisma from '../config/prisma.js';
import { generateToken } from '../utils/jwt.js';

export class AuthService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;  // Utilisation de l'instance partagée
    }

    public async register(profileData: any, file?: Express.Multer.File): Promise<Utilisateur> {
        try {
            let photoUrl: string | undefined;

            if (file) {
                try {
                    const result = await new Promise<any>((resolve, reject) => {
                        const uploadStream = cloudinary.uploader.upload_stream({ folder: 'profiles' }, (error, result) => {
                            if (error) reject(error);
                            resolve(result);
                        });
                        uploadStream.end(file.buffer);
                    });
                    photoUrl = result.secure_url;
                   // console.log("Photo URL:", photoUrl);  // Vérifier l'URL de la photo
                } catch (uploadError) {
                    console.error('Erreur lors du téléchargement du fichier:', uploadError);
                    throw new Error('Erreur lors du téléchargement du fichier');
                }
            }

          //  console.log("Profile Data:", profileData);  // Vérifiez les données du profil avant l'insertion

            const hashPassword = await bcrypt.hash(profileData.motDePasse, 10);
            const newUser = await this.prisma.utilisateur.create({
                data: {
                    ...profileData,
                    motDePasse: hashPassword,
                    photo: photoUrl,
                },
            });

            console.log("Nouveau utilisateur créé:", newUser);  // Vérifiez l'utilisateur créé

            // Créer l'entrée dans la table associée en fonction du rôle
            if (profileData.role === 'CLIENT') {
                await this.prisma.client.create({
                    data: {
                        utilisateurId: newUser.id,
                    },
                });
            } else if (profileData.role === 'TAILLEUR') {
                await this.prisma.tailleur.create({
                    data: {
                        utilisateurId: newUser.id,
                    },
                });
            }

            return newUser;
        } catch (err) {
            console.error('Erreur lors de l\'enregistrement:', err);
            throw new Error('Erreur lors de l\'enregistrement de l\'utilisateur');
        }
    }

    public async login(login: string, motDePasse: string): Promise<{ utilisateur: Utilisateur; token: string }> {
        try {
            const utilisateur = await this.prisma.utilisateur.findUnique({
                where: { login },
            });

            if (!utilisateur || !await bcrypt.compare(motDePasse, utilisateur.motDePasse)) {
                throw new Error('Login ou mot de passe incorrect');
            }

            const token = generateToken(utilisateur.id, utilisateur.role);
            return { utilisateur, token };
        } catch (err) {
            console.error('Erreur lors de la connexion:', err);
            throw new Error('Erreur lors de la connexion');
        }
    }
}
