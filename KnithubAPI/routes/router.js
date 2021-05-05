const varController = require('../controllers/SPControllers.js');
const express = require('express');
const router = express.Router();

router.get("/compraPatrones", (req, res) => {

    const { macaddress } = req.body;
    const { username } = req.body;
    const { userlastname } = req.body;

    if (!macaddress){
        console.log(`Request from ${req.ip} to  path ${req.url} was invalid, code 418, no name.`)
        res.status(418).send({ message: 'There was an error.' })
    } else {
        varController.getInstance().compraPatrones(macaddress,username,userlastname);
    }
    res.json({ message: "Ok"});
});

module.exports=router;