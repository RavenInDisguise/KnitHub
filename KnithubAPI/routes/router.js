const varController = require('../controllers/SPControllers.js');
const express = require('express');
const router = express.Router();

router.get("/compraPatrones", (req, res) => {
    varController.getInstance().compraPatrones(req, res);

});
router.get("/compraPlanes", (req, res) => {
    varController.getInstance().compraPlanes(req, res);
});
router.post("/cronometrajeProyectos", (req, res) => {
    varController.getInstance().cronometrajeProyectos(req, res);
});
router.get("/patronesVenta", (req, res) => {
    varController.getInstance().patronesEnVenta(req, res);
});
module.exports=router;