// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'second.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assessment 2',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 251, 255),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _icontext = true;

  void _togglePasswordVisibility() {
    setState(() {
      _icontext = !_icontext;
    });
  }

  void _login() {
    String username = usernameController.text;
    String password = passwordController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(
          username: username,
          password: password,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: NetworkImage(
                    'https://i1.sndcdn.com/artworks-3x2S3foRdDbeR735-H5IEfg-t500x500.jpg'),
                width: 500,
                height: 400,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 50),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  // Pindah fokus ke password field
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _icontext,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _icontext ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                onSubmitted: (_) {
                  _login();
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
