const express = require('express');
const app=express();
const mysql= require('mysql2');

//Config server 
app.set('port', process.env.PORT || 8080);

//Middleware
app.use(express.json());

//Routes
app.use(require('./routes/router.js'));

//Starting server
app.listen(app.get('port'), () => {
    console.log('Server on port', app.get('port'))
});

