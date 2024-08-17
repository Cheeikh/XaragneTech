import { z } from 'zod';

export class ServiceValidator {
    private ServiceSchema = z.object({
        type: z.enum(['MODELE_PRET','COMMANDE_SUR_MESURE','REPARATION']).transform((val) => val.toUpperCase() as 'HOMMODELE_PRETME' | 'COMMANDE_SUR_MESURE'|'REPARATION'),
        nom: z.string().min(1, { message: "Le nom est requis" }),
        description: z.string().min(1, { message: "La description est requise" }),
        prixBase: z.preprocess((val) => parseFloat(val as string), z.number().positive({ message: "Le prix de base doit être positif" })),
        stock: z.preprocess((val) => parseInt(val as string, 10), z.number().nonnegative({ message: "Le stock ne peut pas être négatif" })),
    });

    public validate(data: any) {
        try {
            const validatedData = this.ServiceSchema.parse(data);
            return { data: validatedData };
        } catch (error) {
            return { error, data: "Erreur de validation" };
        }
    }
}
