import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project1/model/member.dart';
import 'package:project1/views/bookingscreen.dart';
import 'package:project1/views/deluxe_room.dart';
import 'package:project1/views/loginscreen_ui.dart';
import 'package:project1/sql/rooms.dart' as r;
import 'package:project1/views/standard_room.dart';
import 'package:project1/views/suite_room.dart';
import 'package:project1/views/userdeails.dart';

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
            NestedTabBar(member: member),
            // ตรวจสอบก่อนที่จะสร้างหน้าจอ BookingScreenUI
            member != null && member.id != null
                ? BookingScreenUI(userId: member.id)
                : Container(child: Text('User ID is null or member is null')),
            UserDetailsUI(),
          ],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({Key? key, required this.member});

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
    _tabController = TabController(length: 1, vsync: this);
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
              FutureBuilder<List<Map<String, dynamic>>>(
                future: r.getRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var room = snapshot.data![index];

                        return ListTile(
                          onTap: () {
                            if (room['room_type'] == 'standardRoom') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StandardRoomUI( 
                                      roomType: 'Standard Room',
                                      userId: widget.member.id ?? 0),
                                ),
                              );
                            } else if (room['room_type'] == 'deluxeRoom') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeluxeRoomUI(
                                      roomType: 'Deluxe Room',
                                      userId: widget.member.id ?? 0),
                                ),
                              );
                            } else if (room['room_type'] == 'suiteRoom') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SuiteRoomUI(
                                      roomType: 'Suite Room',
                                      userId: widget.member.id ?? 0),
                                ),
                              );
                            }
                          },
                          title: Text(room['room_type'] ?? ''),
                          subtitle: Text(
                            'ราคา: ${room['price'] ?? ''} บาท\nสิ่งอำนวยความสะดวก: ${room['amenities'] ?? ''}',
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

Future<Widget> loadImage(String url) async {
  try {
    final file = File(url);
    final bytes = await file.readAsBytes();
    final image = Image.memory(bytes);
    return image;
  } catch (e) {
    print('Error loading image: $e');
    return Icon(Icons.error);
  }
}


