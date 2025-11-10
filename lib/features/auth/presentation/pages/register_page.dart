import 'package:flutter/material.dart';
import 'package:ganlink/features/main/main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isHiden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Username",
                ),
              ),
            ),
          
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "First name",
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Last name",
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isHiden = !_isHiden;
                      });
                    },
                    icon: Icon(
                      _isHiden ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                obscureText: _isHiden,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  ),
                  child: Text('Register'),
                ),
              ),
            ),

            TextButton(onPressed: () => Navigator.pop(context), child: Text("Login")),
          ],
        ),
      ),
    );
  }
}