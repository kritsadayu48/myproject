import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project1/model/member.dart';
import 'package:project1/views/bookingscreen.dart';
import 'package:project1/views/loginscreen_ui.dart';
import 'package:project1/sql/rooms.dart' as r;

class HomeScreenUI extends StatelessWidget {
  const HomeScreenUI({Key? key, required this.member}) : super(key: key);

  final Member member;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: TabBarExample(member: member),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({Key? key, required this.member}) : super(key: key);

  final Member member;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ยินดีต้อนรับคุณ ${member.memFullname}'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => loginscreen_ui()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'หน้าหลัก(Home)',
                icon: Icon(Icons.door_back_door),
              ),
              Tab(
                text: 'รายการห้องพัก',
                icon: Icon(Icons.luggage),
              ),
              Tab(
                text: 'รายละเอียดผู้ใช้',
                icon: Icon(Icons.person_3_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            NestedTabBar('Flights', member: member),
            NestedTabBar('Trips', member: member),
            NestedTabBar('Explore', member: member),
          ],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar(this.outerTab, {Key? key, required this.member});

  final String outerTab;
  final Member member;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              // แท็บแรก: ข่าวสาร
              ListView.builder(
                itemCount:
                    1, // จำนวนรายการข่าวสาร (สามารถเปลี่ยนแปลงตามความต้องการ)
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('ข่าวสารที่ ${index + 1}'),
                    subtitle: Text('รายละเอียดข่าวสารที่ ${index + 1}'),
                  );
                },
              ),
              // แท็บที่สอง: รายการห้องพัก
              FutureBuilder<List<Map<String, dynamic>>>(
                future: r.getRooms(), // เรียกใช้เมธอดเพื่อดึงข้อมูลห้องพัก
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // แสดง Indicator ในระหว่างโหลดข้อมูล
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // แสดงข้อความเมื่อเกิดข้อผิดพลาดในการโหลดข้อมูล
                  } else {
                    // แสดงรายการห้องพัก
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var room = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookingScreenUI()),
                            );
                          },
                          child: ListTile(
                            title: Text(room['room_type'] ?? ''),
                            subtitle: Text(
                              'ราคา: ${room['price'] ?? ''} บาท\nสิ่งอำนวยความสะดวก: ${room['amenities'] ?? ''}',
                            ),
                            leading: FutureBuilder<Widget>(
                              future: loadImage(room['image'] ?? ''),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Icon(Icons.error);
                                } else {
                                  return snapshot.data ?? Icon(Icons.image);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ฟังก์ชั่นสำหรับโหลดรูปภาพจาก URL หรือ Path
Future<Widget> loadImage(String url) async {
  try {
    // ใช้ File API ในการอ่านข้อมูลรูปภาพ
    final file = File(url);
    final bytes = await file.readAsBytes();
    final image = Image.memory(bytes);
    return image;
  } catch (e) {
    print('Error loading image: $e');
    return Icon(Icons.error);
  }
}
