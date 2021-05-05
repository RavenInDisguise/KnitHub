module.exports = class SPController { 
    static instance;
    dbconnection;

    constructor(){
        try
        {
            dbconnection = mysql.createConnection({
            host: 'localhost',
            user: 'root',
            password: '123456',
            database: 'KnitHub',
            });
        } catch (e)
        {
            console.log(`There was an error during the connection process.`);
        }
    }

    compraPatrones(macaddress,username,userlastname){
        //console.log(`Request from ${req.ip} to  path ${req.url}.`)    
        //connection.query('CALL CompraPatrones VALUE (?,?,?)',
        dbconnection.query('CALL CompraPatrones()',
        //[macaddress,username,userlastname],
        [],
        (err, data, fields) => {
            if (err) throw err;
            res.status(200).json({
                data,
            })
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