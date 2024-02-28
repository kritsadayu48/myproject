import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Booking {
  final int id;
  final String room_type;
  final double price;
  final DateTime confirmation_time;
  final int userId; // Add userId field

  Booking({
    required this.id,
    required this.room_type,
    required this.price,
    required this.confirmation_time,
    required this.userId, // Initialize userId field
  });

  factory Booking.fromRow(ResultRow row) {
    var priceString = row[2] as String? ?? '';
    double price = 0.0;
    try {
      price = double.parse(priceString);
    } catch (e) {
      print('Error parsing price: $e');
    }

    DateTime confirmationTime;
    try {
      confirmationTime = DateTime.parse(row[4] as String);
    } catch (e) {
      print('Error parsing confirmation time: $e');
      confirmationTime = DateTime.now(); // Default value if parsing fails
    }

    return Booking(
      id: row[0] as int,
      room_type: row[1] as String,
      price: price,
      confirmation_time: confirmationTime,
      userId: row[5] as int, // Assign userId
    );
  }
}

class DatabaseService {
  final MySqlConnection _connection;

  DatabaseService(this._connection);

  Future<List<Booking>> fetchBookings(int userId) async {
    final results = await _connection.query('SELECT * FROM bookings WHERE userId = ?', [userId]);
    return results.map((row) => Booking.fromRow(row as ResultRow)).toList();
  }
}

class BookingScreenUI extends StatefulWidget {
  final int userId; // Add userId field

  const BookingScreenUI({Key? key, required this.userId}) : super(key: key);

  @override
  State<BookingScreenUI> createState() => _BookingScreenUIState();
}

class _BookingScreenUIState extends State<BookingScreenUI> {
  late List<Booking> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final settings = ConnectionSettings(
      host: 'sautechnology.com',
      user: 'u231198616_s6319410013',
      password: 'S@u6319410013',
      db: 'u231198616_s6319410013_db',
    );

    final connection = await MySqlConnection.connect(settings);
    final databaseService = DatabaseService(connection);

    final bookings = await databaseService.fetchBookings(widget.userId); // Pass userId

    setState(() {
      _bookings = bookings;
    });

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการห้องพัก'),
      ),
      body: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          return ListTile(
            title: Text('ห้อง: ${booking.room_type}'),
            subtitle: Text('ราคา: ${booking.price.toStringAsFixed(2)} บาท'),
          );
        },
      ),
    );
  }
}
