import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rutaspractica/screen/home.dart';
import 'package:rutaspractica/screen/resources/datosContenido.dart';

class ContenidoPage extends StatefulWidget {
  final int categoriaId;
  final String token;
  // const ContenidoPage({required this.categoriaId, required this.token});
  const ContenidoPage({Key? key,required this.categoriaId, required this.token}) : super(key: key);

  @override
  State<ContenidoPage> createState() => _ContenidoPageState();
}

class _ContenidoPageState extends State<ContenidoPage> {
  late Future<List<Map<String, dynamic>>> futureContenido;

  @override
  void initState() {
    super.initState();
    futureContenido = fetchContenido(widget.categoriaId);

  }

  Future<List<Map<String, dynamic>>> fetchContenido(int id) async {
    final response = await http.get(Uri.parse(
        'https://04f7-2803-9400-3-d5d2-925-5e6e-e02-31a.ngrok-free.app/GradeContenido/get/$id'),
        headers: <String, String>{
        'Authorization': 'Bearer ${widget.token}',
      },
        );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load contenido');
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
              MaterialPageRoute(builder: (context) => HomePage(token: widget.token)),
            );
          },
        ),
        title: const Text('Contenido de la Categoría '),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureContenido,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final contenido = snapshot.data![index];
                return ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                    context,
                        MaterialPageRoute(builder: (context) => DatosContenidoPage( datosContenidoId: contenido['id'], token :widget.token,categoriaId : widget.categoriaId)),
                      );
                  },

                  label: Text(contenido['name']),
                  icon: const Icon(Icons.arrow_forward),

                  // subtitle: Text(contenido['reference']),/
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
