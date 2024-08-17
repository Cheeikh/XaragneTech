import { PrismaClient, Service, ServiceImage } from '@prisma/client';
import cloudinary from '../config/cloudinary.js';
import prisma from '../config/prisma.js';

export class ServiceService {
    private prisma: PrismaClient;

    constructor() {
        this.prisma = prisma;  // Utilisation de l'instance partagée
    }

    async createService(data: any, files: Express.Multer.File[], tailleurId: number): Promise<Service> {
        try {
            // Création du service dans la base de données
            const service = await this.prisma.service.create({
                data: {
                    ...data,
                    tailleurId: tailleurId,
                },
            });

            // Gestion des fichiers (images) si fournis
            if (files && files.length > 0) {
                await this.uploadAndLinkImages(service.id, files);
            }

            return service;
        } catch (err) {
            console.error('Erreur lors de la création du service:', err);
            throw new Error('Erreur lors de la création du service');
        }
    }

    async getServiceById(id: number): Promise<Service | null> {
        try {
            const service = await this.prisma.service.findUnique({
                where: { id },
                include: { images: true }, // Inclure les images associées
            });

            if (!service) {
                throw new Error('Service non trouvé');
            }

            return service;
        } catch (err) {
            console.error('Erreur lors de la récupération du service:', err);
            throw new Error('Erreur lors de la récupération du service');
        }
    }

    async getAllServices(): Promise<Service[]> {
        try {
            return await this.prisma.service.findMany({
                include: { images: true }, // Inclure les images associées
            });
        } catch (err) {
            console.error('Erreur lors de la récupération des services:', err);
            throw new Error('Erreur lors de la récupération des services');
        }
    }

    async updateService(id: number, data: any, files: Express.Multer.File[]): Promise<Service> {
        try {
            const service = await this.prisma.service.update({
                where: { id },
                data: {
                    ...data,
                },
            });

            // Si de nouveaux fichiers sont fournis, les télécharger et les lier au service
            if (files && files.length > 0) {
                await this.uploadAndLinkImages(service.id, files);
            }

            return service;
        } catch (err) {
            console.error('Erreur lors de la mise à jour du service:', err);
            throw new Error('Erreur lors de la mise à jour du service');
        }
    }

    async deleteService(id: number): Promise<Service> {
        try {
            // Supprimer les images associées au service
            await this.prisma.serviceImage.deleteMany({
                where: { serviceId: id },
            });

            return this.prisma.service.delete({
                where: { id },
            });
        } catch (err) {
            console.error('Erreur lors de la suppression du service:', err);
            throw new Error('Erreur lors de la suppression du service');
        }
    }

    private async uploadAndLinkImages(serviceId: number, files: Express.Multer.File[]): Promise<void> {
        const imageUrls = await Promise.all(files.map(async (file) => {
            try {
                const result = await new Promise<any>((resolve, reject) => {
                    const uploadStream = cloudinary.uploader.upload_stream({ folder: 'service_images' }, (error, result) => {
                        if (error) reject(error);
                        resolve(result);
                    });
                    uploadStream.end(file.buffer);
                });
                return result.secure_url;
            } catch (uploadError) {
                console.error('Erreur lors du téléchargement du fichier:', uploadError);
                throw new Error('Erreur lors du téléchargement du fichier');
            }
        }));

        await this.prisma.serviceImage.createMany({
            data: imageUrls.map(url => ({
                serviceId,
                url,
            })),
        });
    }
}
