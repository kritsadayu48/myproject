const express = require('express');
const mysql = require('mysql');

const app = express();

// การกำหนดค่าสำหรับการเชื่อมต่อฐานข้อมูล MySQL
const connection = mysql.createConnection({
  host: 'sautechnology.com',
  user: 'u231198616_s6319410013', // แทนที่ 'root' ด้วยชื่อผู้ใช้ MySQL
  password: 'S@u6319410013', // แทนที่ 'password' ด้วยรหัสผ่าน MySQL
  database: 'u231198616_s6319410013_db' // แทนที่ 'your_database' ด้วยชื่อฐานข้อมูล MySQL
});

// เชื่อมต่อกับ MySQL
connection.connect();

// API สำหรับการรับข้อมูล users
app.get('/users', (req, res) => {
  // ส่งคำขอ SQL เพื่อดึงข้อมูล users จากฐานข้อมูล
  connection.query('SELECT * FROM users', (error, results, fields) => {
    if (error) throw error;
    res.json(results); // ส่งข้อมูล users กลับไปยังผู้ใช้
  });
});

// กำหนดพอร์ตที่ Express.js จะใช้งาน
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
