const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path'); // <== Ajouté pour servir l'app Flutter Web

const userRoute = require('./Routes/userRoute');
const reservationRoutes = require('./Routes/reservationRoute');
const spacesRoutes = require('./Routes/spaceRoute');

dotenv.config();

const app = express();

// Middleware CORS
const corsOptions = {
                origin: ['http://127.0.0.1:5501', 'http://localhost:5500', 'http://127.0.0.1:5500'],
                methods: ['GET', 'POST', 'PUT', 'DELETE'],
                credentials: true
};

app.use(cors(corsOptions));
app.use(express.json());

// Middleware de logging des requêtes
app.use((req, res, next) => {
                console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
                next();
});

// Routes API
app.use('/user', userRoute);
app.use('/reservations', reservationRoutes);
app.use('/spaces', spacesRoutes);

// ✅ Servir les fichiers statiques de l'application Flutter Web
app.use(express.static(path.join(__dirname, 'public')));

// ✅ Rediriger toutes les routes vers index.html (SPA Flutter)
app.get('*', (req, res) => {
                res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Middleware 404 pour API
app.use((req, res, next) => {
                res.status(404).json({ message: "Cette ressource n'existe pas" });
});

// Middleware global de gestion d'erreurs
app.use((err, req, res, next) => {
                console.error("❌ ERREUR SERVEUR :", err);
                res.status(500).json({
                                message: "Une erreur interne est survenue",
                                error: process.env.NODE_ENV === 'production' ? null : err.message
                });
});

// Gestion des erreurs critiques
process.on('uncaughtException', (err) => {
                console.error("🔥 ERREUR CRITIQUE :", err);
});

process.on('unhandledRejection', (reason, promise) => {
                console.error("🔥 PROMESSE NON GÉRÉE :", reason);
});

// Lancement du serveur
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
                console.log(`✅ Serveur à l'écoute sur http://82.96.161.255:${PORT}`);
});

module.exports = app;
