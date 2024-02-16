import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/views/loginscreen_ui.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _username, _email, _age, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (value) => _password = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Username';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Age';
                    }
                    return null;
                  },
                  onSaved: (value) => _age = value!,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      var url =
                          'https://s6319410013.sautechnology.com/loginapi/apis/register_api.php';
                      var response = await http.post(
                        Uri.parse(url),
                        body: {
                          'memFullname': _name,
                          'memEmail': _email,
                          'memPassword': _password,
                          'memUsername': _username,
                          'memAge': _age,
                        },
                      );

                      if (response.statusCode == 200) {
                        print('Registration successful');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => loginscreen_ui(),
                          ),
                        );
                      } else {
                        print('Error registering user');
                        // แสดงข้อความแจ้งเตือนถ้ามีข้อผิดพลาด
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error registering user'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
