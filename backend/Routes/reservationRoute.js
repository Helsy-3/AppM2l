const express = require('express');
const router = express.Router();
const reservationController = require('../Controllers/reservationController');
const { authenticator } = require('../Middleware/authentificator');

console.log("✅ Fichier reservationRoute.js chargé !");

// Routes pour les réservations
router.post('/createReservation', authenticator, reservationController.createReservation);
router.post('/check-availability', authenticator, reservationController.checkAvailability);
router.post('/cancelReservation', authenticator, reservationController.cancelReservation);



module.exports = router;