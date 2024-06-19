import 'package:flutter/material.dart';
import 'package:rutaspractica/screen/home.dart';
import 'package:rutaspractica/screen/login/register.dart';
import 'package:rutaspractica/screen/login/singin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => BaseLoginPageState();
}

class BaseLoginPageState extends State<LoginPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const Icon(Icons.android, size: 200, color:Colors.greenAccent),
            ElevatedButton(onPressed: () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()),)},child: Text('signin')),
            ElevatedButton(onPressed: () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()),)},child: Text('Register')),
            // ElevatedButton(onPressed: () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),)},child: Text('Home')),
          ],
            )
        ),
      );
  }
}