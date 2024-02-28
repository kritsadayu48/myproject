const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 3000;

const connection = mysql.createConnection({
    host: 'sautechnology.com',
    user: 'u231198616_s6319410013',
    password: 'S@u6319410013',
    db: 'u231198616_s6319410013_db',
});

connection.connect();

app.get('/users', (req, res) => {
  connection.query('SELECT * FROM users', (error, results) => {
    if (error) throw error;
    res.json(results);
  });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
