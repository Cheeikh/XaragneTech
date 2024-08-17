import { app } from './app.js';

const PORT: number = process.env.PORT ? parseInt(process.env.PORT) : 5000;

app.listen(PORT, () => {
    console.log(`Le serveur tourne sur le port ${PORT}`);
});

