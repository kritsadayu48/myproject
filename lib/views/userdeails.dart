import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/util/env.dart';

class UserDetailsUI extends StatefulWidget {
  const UserDetailsUI({Key? key}) : super(key: key);

  @override
  State<UserDetailsUI> createState() => _UserDetailsUIState();
}

class _UserDetailsUIState extends State<UserDetailsUI> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(Uri.decodeFull(Env.apiURL+'/get_all_user_api.php')),
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          users = responseData.map((data) => User.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
