<?php
// ตั้งค่าการเชื่อมต่อกับ MySQL
$servername = "sautechnology.com";
$username = "u231198616_s6319410013"; // ชื่อผู้ใช้งานฐานข้อมูล MySQL
$password = "S@u6319410013"; // รหัสผ่านฐานข้อมูล MySQL
$dbname = "u231198616_s6319410013_db"; // ชื่อฐานข้อมูล MySQL

// ตรวจสอบการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

// รับข้อมูลที่ส่งมาจากการเรียกใช้ API
$roomType = $_POST['room_type'];
$price = $_POST['price']; // เพิ่มการรับข้อมูลราคา

$receiptImage = $_FILES['receipt_image_path'];

// ตรวจสอบว่ามีการส่งรูปภาพมาหรือไม่
if (isset($receiptImage)) {
  $target_dir = "uploads/";
  $target_file = $target_dir . basename($receiptImage["name"]);
  move_uploaded_file($receiptImage["tmp_name"], $target_file);
} else {
  // ไม่มีการส่งรูปภาพ
}

// เตรียมคำสั่ง SQL สำหรับการเพิ่มข้อมูลการจองลงในฐานข้อมูล
$sql = "INSERT INTO bookings (room_type, price, receipt_image_path) VALUES ('$room_type', '$price', '$target_file')"; // เพิ่มข้อมูลราคาลงในคำสั่ง SQL

// ทำการเพิ่มข้อมูลลงในฐานข้อมูล
if ($conn->query($sql) === TRUE) {
  echo "Booking and receipt image uploaded successfully";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

// ปิดการเชื่อมต่อกับ MySQL
$conn->close();
?>
