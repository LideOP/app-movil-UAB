import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rutaspractica/screen/login/login.dart';
import 'package:rutaspractica/screen/login/singin.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: const Icon(Icons.arrow_back), // Icono para indicar "volver"
        onPressed: () {
          Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
        
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Asigna la clave al Form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    formData['nombre'] =
                        value; // Actualiza el valor del campo apellido en formData
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Apellido'),
                onChanged: (value) {
                  setState(() {
                    formData['apellido'] =
                        value; // Actualiza el valor del campo apellido en formData
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Teléfono'),
                onChanged: (value) {
                  setState(() {
                    formData['telefono'] =
                        value; // Actualiza el valor del campo apellido en formData
                  });
                },
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'CI'),
                onChanged: (value) {
                  setState(() {
                    formData['ci'] =
                        value; // Actualiza el valor del campo apellido en formData
                  });
                },
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                onChanged: (value) {
                  setState(() {
                    formData['email'] =
                        value; 
                  });
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(labelText: 'username'),
                onChanged: (value) {
                  setState(() {
                    formData['username'] =
                        value; 
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(labelText: 'password'),
                onChanged: (value) {
                  setState(() {
                    formData['password'] =
                        value; 
                  });
                },
              ),
              const SizedBox(height: 20), // Espacio entre los campos
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitForm();
                    // Si el formulario es válido, procesa el envío
                    print('Formulario enviado');
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return; // Si el formulario no es válido, termina la función
    }

    // Aquí es donde recolectamos los datos del formulario
    formData['nombre'] = formData['nombre'];
    formData['apellido'] = formData['apellido'];
    formData['telefono'] = formData['telefono'];
    formData['ci'] = formData['ci'];
    formData['username'] = formData['username'];
    formData['email'] = formData['email'];
    formData['password'] = formData['password'];

    // Ahora, enviamos los datos al backend
    try {
      var uuid = const Uuid();
      String generatedGuid = uuid.v4();
      var url = Uri.parse(
          'https://04f7-2803-9400-3-d5d2-925-5e6e-e02-31a.ngrok-free.app/Usuario/Create');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiRGFuaWVsIiwic3ViIjoic2hhcms4IiwicGVybWlzc2lvbiI6ImVzY3JpdHVyYSIsImp0aSI6Ijc0YmMwNmU1LTk2MGMtNGVmOC05NjIzLTE1OTA0OGQ1MDMwMCIsImV4cCI6MTcxODY5MTgwMiwiaXNzIjoieW91cmRvbWFpbi5jb20iLCJhdWQiOiJ5b3VyZG9tYWluLmNvbSJ9.EPAE6ENsbBGgUK4vq-AF4gzRWqM6W4M266EqPUOqSt0",
        },
        body: jsonEncode({
          "persona": {
            "id": generatedGuid,
            "nombre": formData['nombre'],
            "apellido": formData['apellido'],
            "telefono": formData['telefono'].toString(),
            "ci": formData['ci'].toString()
          },
          "username": formData['username'],
          "email": formData['email'],
          "password": formData['password']
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Registro exitoso')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Contrasenia invalida')));
      } 
      else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Usuario inexsistente, REGISTRATE!')));
      }
      else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al registrar')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error desconocido')));
    }
  }
}
