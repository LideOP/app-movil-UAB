import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:rutaspractica/screen/resources/contenido.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DatosContenidoPage extends StatefulWidget {
  final int datosContenidoId;
  final String token;
  final int categoriaId;

  const DatosContenidoPage(
      {Key? key,
      required this.datosContenidoId,
      required this.categoriaId,
      required this.token})
      : super(key: key);
  @override
  State<DatosContenidoPage> createState() => _DatosContenidoPageState();
}

class _DatosContenidoPageState extends State<DatosContenidoPage> {
  late Future<Map<String, dynamic>> futureDatosContenido;

  @override
  void initState() {
    super.initState();
    futureDatosContenido = fetchDatosContenido(widget.datosContenidoId);
    // futureDatosContenido = fetchDatosContenido(widget.categoriaId);
  }

  Future<Map<String, dynamic>> fetchDatosContenido(int id) async {
    final response = await http.get(
      Uri.parse(
          'https://04f7-2803-9400-3-d5d2-925-5e6e-e02-31a.ngrok-free.app/Contenido/byId/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Error al consumir la api');
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
              MaterialPageRoute(
                builder: (context) => ContenidoPage(
                  categoriaId: widget.categoriaId,
                  token: widget.token,
                ),
              ),
            );
          },
        ),
        title: const Text('Datos del contenido'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureDatosContenido,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData) {
            final datos = snapshot.data!;
            return ListView(
              children: [
                ListTile(
                  title: Text(datos['name']),
                  subtitle: _buildContent(datos),

                  // subtitle: datos['description'] != null
                  //     ? Image.network(
                  //         datos['description'],
                  //         errorBuilder: (context, error, stackTrace) {
                  //           return const Text('Error al cargar la imagen');
                  //         },
                  //       )
                  //     : const Text('No image available'),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> datos) {
    switch (datos['contentType']) {
      case 0: // Audio
        return _buildAudio(datos['description']);
      case 1: // Video
        return _buildVideo(datos['description']);
      case 2: // Imagen
        return _buildImage(datos['description']);
      case 3: // URL
        return _buildUrl(datos['description']);
      case 4: // PDF
        return _buildPdf(datos['description']);
      default:
        return const Text('Tipo de contenido desconocido');
    }
  }

  Widget _buildAudio(String url) {
    // Implementar el widget para reproducir audio
    return const Text('Audio content not yet implemented');
  }

  Widget _buildVideo(String url) {
    return GestureDetector(
      onTap: () => _launchURLInChrome(url),
      child: const Text(
        'Open Video in Chrome',
        style:
            TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) {
        return const Text('Error al cargar la imagen');
      },
    );
  }

  Widget _buildUrl(String url) {
    return GestureDetector(
      onTap: () => _launchURLInChrome(url),
      child: const Text(
        'Open Link',
        style:
            TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildPdf(String url) {
    return GestureDetector(
      onTap: () => _launchURLInChrome(url),
      child: const Text(
        'Open PDF',
        style:
            TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
      ),
    );
  }

  void _launchURLInChrome(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showErrorDialog('No se pudo iniciar $url');
      }
    } else {
      _showErrorDialog('No se pudo iniciar $url');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
