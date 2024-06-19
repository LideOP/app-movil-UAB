
import 'package:flutter/material.dart';
import 'package:rutaspractica/screen/login/register.dart';
import 'package:rutaspractica/screen/home.dart';
import 'package:rutaspractica/screen/login/singin.dart';
import 'package:rutaspractica/screen/login/login.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'signin':(context) => const SignInPage(),
        'login': (context) => const LoginPage(),
        'register':(context) => const RegisterPage(),
        'home': (context) => const HomePage(token:''),
        // 'contenido': (context) => ContenidoPage(categoriaId:0),
      },
      // home: const HomePage(),
  );
 }
}