import 'package:mysql1/mysql1.dart';

Future<List<Map<String, dynamic>>> getRooms() async {
  try {
    var settings = ConnectionSettings(
       host: 'sautechnology.com',
      user: 'u231198616_s6319410013',
      password: 'S@u6319410013',
      db: 'u231198616_s6319410013_db',
    );  

    var conn = await MySqlConnection.connect(settings);  

    var results = await conn.query('SELECT * FROM rooms'); 

    await conn.close(); 

    List<Map<String, dynamic>> rooms = results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'room_type': row['room_type'],
      'confirmation_time': row['confirmation_time'] // เพิ่มข้อมูลเวลายืนยันการจอง
    }).toList();
    return rooms;
  } catch (e) {
    print('Error fetching rooms: $e');
    return [];
  }
}
