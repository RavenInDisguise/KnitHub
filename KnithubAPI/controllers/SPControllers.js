const mysql= require('mysql2');

module.exports = class SPController { 
    static instance;
    dbconnection;

    constructor(){
        try
        {
            this.dbconnection = mysql.createConnection({
            host: 'localhost',
            user: 'root',
            password: '123456',
            database: 'KnitHub'
            });
        } catch (e)
        {
            console.log(`There was an error during the connection process.`,e);
        }
    }
    compraPatrones(req,res){
        const { macaddress } = req.body;
        const { username } = req.body;
        const { userlastname } = req.body;
        const { patterntitle } = req.body;
        const { macaddressO } = req.body;
        const { usernameO } = req.body;
        const { userlastnameO } = req.body;
        console.log(macaddress,", ",username,", ", userlastname,", ", patterntitle,", ",macaddressO,", ",usernameO,", ", userlastnameO)
        console.log(`Request from ${req.ip} to  path ${req.url}.`)
        if (!macaddress || !username || !userlastname || !patterntitle){
            console.log(`Request from ${req.ip} to  path ${req.url} was invalid, code 418, no data.`)
            res.status(418).send({ message: 'There was an error.' })
        }
        else{    
            this.dbconnection.execute('CALL CompraPatrones (?,?,?,?,?,?,?)',
            [macaddress,username,userlastname,patterntitle,macaddressO,usernameO,userlastnameO],
            (err, data, fields) => {
                if (err) throw err;
                res.status(200).json({data})
            })
        }
    }
    compraPlanes(req,res){
        const { macaddress } = req.body;
        const { username } = req.body;
        const { userlastname } = req.body;
        const { plantitle } = req.body;
        console.log(macaddress,", ",username," and ", userlastname," and ",plantitle )
        console.log(`Request from ${req.ip} to  path ${req.url}.`)
        if (!macaddress || !username || !userlastname || !plantitle){
            console.log(`Request from ${req.ip} to  path ${req.url} was invalid, code 418, no data.`)
            res.status(418).send({ message: 'There was an error.' })
        }
        else{    
            this.dbconnection.execute('CALL CompraPlanes (?,?,?,?)',
            [macaddress,username,userlastname,plantitle],
            (err, data, fields) => {
                if (err) throw err;
                res.status(200).json({data})
            })
        }
    }
    cronometrajeProyectos(req, res){
        const { macaddress } = req.body;
        const { username } = req.body;
        const { userlastname } = req.body;
        const { projectName } = req.body;
        console.log(req.body)
        console.log(macaddress,", ",username,", ", userlastname," and", projectName)
        console.log(`Request from ${req.ip} to  path ${req.url}.`)
        if (!macaddress || !username || !userlastname || !projectName){
            console.log(`Request from ${req.ip} to  path ${req.url} was invalid, code 418, no data.`)
            res.status(418).send({ message: 'There was an error.' })
        }
        else{    
            this.dbconnection.execute('CALL CronometrajeProyectos (?,?,?,?)',
            [macaddress,username,userlastname, projectName],
            (err, data, fields) => {
                if (err) throw err;
                res.status(200).json({data})
            })
        }
    }
    patronesEnVenta(req, res){
        console.log(`Request from ${req.ip} to  path ${req.url}.`)  
        this.dbconnection.execute('CALL PatronesEnVenta()',
        (err, data, fields) => {
            if (err) throw err;
            res.status(200).json({data})
        })
    }
    static getInstance(){
            if (!this.instance)
            {
                this.instance = new SPController();
            }
            return this.instance;
    }
};