XartoumTech/
├── src/
│   ├── config/
│   │   ├── cloudinary.ts            # Configuration Cloudinary
│   │   └── prisma.ts                # Configuration Prisma
│   ├── controllers/
│   │   ├── AuthController.ts        # Contrôleur pour l'authentification
│   │   ├── BloquerController.ts     # Contrôleur pour le blocage des utilisateurs  //Merry
│   │   ├── CommandeController.ts    # Contrôleur pour les commandes                //Fanta
│   │   ├── DiscussionsController.ts # Contrôleur pour les discussions              //cheikh
│   │   ├── EvaluationController.ts  # Contrôleur pour les évaluations              //Merry
│   │   ├── FollowController.ts      # Contrôleur pour le suivi                     //Saer
│   │   ├── MesuresController.ts     # Contrôleur pour les mesures                  //Cheikh
│   │   ├── PostController.ts        # Contrôleur pour les publications             //bobo
│   │   ├── ServiceController.ts     # Contrôleur pour les services                 Deja fait
│   │   ├── SignalementController.ts # Contrôleur pour les signalements             //Saer
│   │   └── StoryController.ts       # Contrôleur pour les stories                  //bobo
│   ├── middlewares/
│   │   ├── AuthMiddleware.ts        # Middleware pour l'authentification
│   ├── routes/
│   │   ├── authRoutes.ts            # Routes pour l'authentification  
│   │   ├── bloquerRoutes.ts         # Routes pour le blocage
│   │   ├── commandeRoutes.ts        # Routes pour les commandes
│   │   ├── discussionsRoutes.ts     # Routes pour les discussions
│   │   ├── evaluationRoutes.ts      # Routes pour les évaluations
│   │   ├── followRoutes.ts          # Routes pour le suivi
│   │   ├── mesuresRoutes.ts         # Routes pour les mesures
│   │   ├── postRoutes.ts            # Routes pour les publications
│   │   ├── servicesRoutes.ts        # Routes pour les services
│   │   ├── signalementRoutes.ts     # Routes pour les signalements
│   │   └── storyRoutes.ts           # Routes pour les stories
│   ├── services/
│   │   ├── AuthService.ts           # Service pour l'authentification
│   │   ├── BloquerService.ts        # Service pour le blocage
│   │   ├── CommandeService.ts       # Service pour les commandes
│   │   ├── DiscussionsService.ts    # Service pour les discussions
│   │   ├── EvaluationService.ts     # Service pour les évaluations
│   │   ├── FollowService.ts         # Service pour le suivi
│   │   ├── MesuresService.ts        # Service pour les mesures
│   │   ├── PostService.ts           # Service pour les publications 
│   │   ├── ServiceService.ts        # Service pour les services
│   │   ├── SignalementService.ts    # Service pour les signalements
│   │   └── StoryService.ts          # Service pour les stories
│   ├── utils/
│   │   ├── response.ts              # Utilitaire pour les réponses HTTP
│   │   ├── jwt.ts                   # Utilitaire pour la gestion des tokens JWT
│   ├── validator/
│   │   ├── UserValidator.ts         # Validation pour les utilisateurs
│   │   ├── PostValidator.ts         # Validation pour les publications
│   │   ├── StoryValidator.ts        # Validation pour les stories
│   │   └── ServiceValidator.ts      # Validation pour les services
│   ├── app.ts                       # Initialisation de l'application Express
│   └── server.ts                    # Démarrage du serveur
├── prisma/
│   ├── schema.prisma                # Schéma Prisma
│   └── migrations/                  # Dossier pour les migrations Prisma
├── .env                             # Variables d'environnement
├── package.json                     # Dépendances et scripts NPM
└── tsconfig.json                    # Configuration TypeScript
