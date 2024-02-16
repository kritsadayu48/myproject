import 'package:mysql1/mysql1.dart';

Future<List<Map<String, dynamic>>> getRooms() async {
  try {
    // กำหนดค่าการเชื่อมต่อ
    var settings = ConnectionSettings(
      host: 'sautechnology.com',
      user: 'u231198616_s6319410013',
      password: 'S@u6319410013',
      db: 'u231198616_s6319410013_db',
    );  

    // เปิดการเชื่อมต่อ
    var conn = await MySqlConnection.connect(settings);  

    // เรียกค้นข้อมูลห้อง 
    var results = await conn.query('SELECT * FROM rooms'); 

    // ปิดการเชื่อมต่อ
    await conn.close(); 

    // แปลงผลลัพธ์เป็นรายการ Map<String, dynamic>
    List<Map<String, dynamic>> rooms = results.map((row) => {
      'id': row['id'],
      'price': row['price'],
      'room_type': row['room_type'],
      'amenities': row['amenities'],
      'image': row['image'],

      // สามารถเพิ่มข้อมูลอื่น ๆ ตามต้องการได้
    }).toList();
    
    return rooms;
  } catch (e) {
    // ในกรณีเกิดข้อผิดพลาดในการเชื่อมต่อหรือการคิวรี่ข้อมูล
    print('Error fetching rooms: $e');
    return [];
  }
}
