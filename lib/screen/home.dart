import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rutaspractica/screen/login/login.dart';
import 'dart:convert';

import 'package:rutaspractica/screen/resources/contenido.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> futureCategorias;

  @override
  void initState() {
    super.initState();
    futureCategorias = fetchCategorias();
  }

  Future<List<Map<String, dynamic>>> fetchCategorias() async {
    final response = await http.get(
      Uri.parse(
          'https://04f7-2803-9400-3-d5d2-925-5e6e-e02-31a.ngrok-free.app/Contenido/GradeGetAll'),
      headers: <String, String>{
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load categorias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),

        title: const Text('Recursos de la Iglesia'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureCategorias,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final categoria = snapshot.data![index];
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children : [
                          Container(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ContenidoPage(categoriaId: categoria['id'], token: widget.token)),
                                );
                              // Navigator.pushNamed(
                              //   context,
                              //   '/contenido',
                              //   arguments: categoria['id'],
                              // );
                              },
                              label: Text(categoria['name'],
                                style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              icon: const Icon(Icons.radio_button_unchecked),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                                alignment: Alignment.centerLeft,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),  
                          ),
                          SizedBox(height: 3),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              return const Center(child: CircularProgressIndicator());
            },
      ),
    );
  }
}
