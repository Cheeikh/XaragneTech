import { z } from 'zod';

export class StoryValidator {
    // Schéma de validation pour les posts
    private PostSchema = z.object({
        titre: z.string().min(1, { message: "Le titre est requis" }).max(100, { message: "Le titre ne peut pas dépasser 100 caractères" }),
        description: z.string().min(1, { message: "La description est requise" }).max(1000, { message: "La description ne peut pas dépasser 1000 caractères" }),

           });

    // Méthode de validation
    public validate(data: any) {
        try {
            const validatedData = this.PostSchema.parse(data);
            return { data: validatedData };
        } catch (error) {
            return { error, data: "Erreur de validation" };
        }
    }
}
