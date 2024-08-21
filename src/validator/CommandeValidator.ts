import { z } from 'zod';

export class CommandeValidator {
    private CommandeSchema = z.object({
        clientId: z.number().int().positive({ message: "L'ID du client est requis et doit être positif" }),
        tailleurId: z.number().int().optional(), // Peut être nul si non spécifié
        vendeurId: z.number().int().optional(), // Peut être nul si non spécifié
        serviceId: z.number().int().positive({ message: "L'ID du service est requis et doit être positif" }),
        quantite: z.preprocess(
            (val) => parseInt(val as string, 10),
            z.number().int().positive({ message: "La quantité doit être un nombre entier positif" })
        ),
        statut: z.enum(['EN_ATTENTE', 'EN_COURS', 'TERMINER']).transform(val => val.toUpperCase() as 'EN_ATTENTE' | 'EN_COURS' | 'TERMINER').optional()
    });

    public validate(data: any) {
        try {
            const validatedData = this.CommandeSchema.parse(data);
            return { data: validatedData };
        } catch (error) {
            return { error, data: "Erreur de validation" };
        }
    }
}
