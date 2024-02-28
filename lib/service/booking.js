const express = require('express');
const mysql = require('mysql');

const app = express();
app.use(express.json());

// กำหนดการเชื่อมต่อกับฐานข้อมูล MySQL
const db = mysql.createConnection({
    host: 'sautechnology.com',
    user: 'u231198616_s6319410013',
    password: 'S@u6319410013',
    db: 'u231198616_s6319410013_db',
});

// เชื่อมต่อกับฐานข้อมูล MySQL
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('MySQL Connected');
});

// สร้างเส้นทาง API สำหรับการบันทึกข้อมูลการจอง
app.post('/api/booking', (req, res) => {
  const { roomType, guestName, checkInDate, checkOutDate } = req.body;
  const query = `INSERT INTO bookings (room_type, guest_name, check_in_date, check_out_date) VALUES ('${roomType}', '${guestName}', '${checkInDate}', '${checkOutDate}')`;
  
  db.query(query, (err, result) => {
    if (err) {
      res.status(500).send('Error saving booking');
      return;
    }
    res.status(200).send('Booking saved successfully');
  });
});

// กำหนดพอร์ตและเริ่มต้นเซิร์ฟเวอร์
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
