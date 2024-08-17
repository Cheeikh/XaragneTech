import { z } from 'zod';

// Définition des enums selon le modèle Prisma
const StateProfileEnum = z.enum(['NORMAL', 'SIGNALER']);
const SexeEnum = z.enum(['HOMME', 'FEMME']);
const RoleEnum = z.enum(['TAILLEUR', 'CLIENT']);

export class UtilisateurValidator {
    private UserSchema = z.object({
        nom: z.string(),
        prenom: z.string(),
        login: z.string(),
        motDePasse: z.string().min(8, 'Le mot de passe doit contenir au moins 8 caractères'),
        adresse: z.string(),
        email: z.string().email('Adresse email invalide'),
        telephone: z.string().min(9, 'Le numéro de téléphone doit contenir au moins 9 chiffres'),
        stateProfiles: StateProfileEnum.default('NORMAL'),
        sexe: z.enum(['HOMME', 'FEMME']).transform((val) => val.toUpperCase() as 'HOMME' | 'FEMME'),
        role: z.enum(['TAILLEUR', 'CLIENT']).transform((val) => val.toUpperCase() as 'TAILLEUR' | 'CLIENT'),
        photo: z.string().optional(), // Ajoutez le champ `photo` comme optionnel ici
    });

    public validate(data: any) {
        try {
            const validatedData = this.UserSchema.parse(data);
            return { data: validatedData };
        } catch (error) {
            return { error, data: "Erreur de validation" };
        }
    }
}
