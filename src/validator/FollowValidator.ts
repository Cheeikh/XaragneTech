import { z } from 'zod';

export class FollowValidator {
    private FollowSchema = z.object({
        followerId: z.string().uuid({ message: "L'ID du follower doit être un UUID valide" }),
        followedId: z.string().uuid({ message: "L'ID du suivi doit être un UUID valide" }),
    });

    public validate(data: any) {
        try {
            const validatedData = this.FollowSchema.parse(data);
            return { data: validatedData };
        } catch (error) {
            return { error, data: "Erreur de validation" };
        }
    }
}
