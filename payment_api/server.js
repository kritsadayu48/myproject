const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");

const app = express();
const port = 3000;

// เชื่อมต่อกับฐานข้อมูล MySQL
const connection = mysql.createConnection({
  host: "sautechnology.com",
  user: "u231198616_s6319410013", // แทนที่ 'root' ด้วยชื่อผู้ใช้ MySQL
  password: "S@u6319410013", // แทนที่ 'password' ด้วยรหัสผ่าน MySQL
  database: "u231198616_s6319410013_db", // แทนที่ 'your_database' ด้วยชื่อฐานข้อมูล MySQL
});

// เชื่อมต่อกับ MySQL
connection.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL: ", err);
    return;
  }
  console.log("Connected to MySQL database");
});

app.use(bodyParser.json());

app.post("/api/booking", (req, res) => {
  const { roomType, bookingDate, paymentDate, amount } = req.body;

  // สร้างคำสั่ง SQL เพื่อเพิ่มข้อมูลการจองลงในฐานข้อมูล
  const sql = `INSERT INTO bookings (room_type, booking_date, payment_date, amount) VALUES (?, ?, ?, ?)`;

  // ส่งคำสั่ง SQL ไปยังฐานข้อมูล
  connection.query(
    sql,
    [roomType, bookingDate, paymentDate, amount],
    (err, result) => {
      if (err) {
        console.error("Error inserting booking into database: ", err);
        res.status(500).send("Error inserting booking into database");
        return;
      }
      console.log("Booking inserted successfully");
      res.status(200).send("Booking received and saved successfully!");
    }
  );
});

app.listen(port, () => {
  console.log(`Server is listening at http://192.168.252.29:${port}`);
});
