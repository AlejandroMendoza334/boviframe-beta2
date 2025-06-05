import 'package:flutter/foundation.dart'; // para kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class NewsDetailScreen extends StatefulWidget {
  final String documentId;
  const NewsDetailScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _loading = true;
  String? _title, _plainContent, _imageUrl, _category, _externalUrl;
  Timestamp? _timestamp;
  String? _fetchedHtml;
  bool _fetchingHtml = false;

  @override
  void initState() {
    super.initState();
    _loadNewsDocument();
  }

  Future<void> _loadNewsDocument() async {
    final doc = await FirebaseFirestore.instance
        .collection('news')
        .doc(widget.documentId)
        .get();

    if (!doc.exists) {
      setState(() { _loading = false; });
      return;
    }

    final data = doc.data()!;
    _title        = data['title'] as String?;
    _plainContent = data['content'] as String?;
    _imageUrl     = data['imageUrl'] as String?;
    _category     = data['category'] as String?;
    _timestamp    = data['timestamp'] as Timestamp?;
    _externalUrl  = data['url'] as String?; // la URL externa (si existe)

    if (_externalUrl != null && _externalUrl!.isNotEmpty) {
      setState(() { _fetchingHtml = true; });
      _fetchedHtml = await _fetchHtmlFromUrl(_externalUrl!);
      setState(() {
        _fetchingHtml = false;
        _loading = false;
      });
    } else {
      setState(() { _loading = false; });
    }
  }

  /// En Android/iOS hacemos GET directo. Solo en Web usamos un proxy (AllOrigins) para CORS.
  Future<String?> _fetchHtmlFromUrl(String url) async {
    try {
      if (kIsWeb) {
        // Si estamos en Flutter Web, usamos un proxy público (AllOrigins) para sortear CORS
        final proxy = Uri.parse(
          'https://api.allorigins.win/raw?url=${Uri.encodeComponent(url)}'
        );
        final response = await http.get(proxy);
        if (response.statusCode == 200) return response.body;
        return null;
      } else {
        // En Android / iOS nativo, no hay restricción CORS, descargamos directo:
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) return response.body;
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cargando…')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_title == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Noticia no encontrada')),
        body: const Center(child: Text('No existe la noticia solicitada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title!),
        backgroundColor: Colors.blue.shade400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageUrl != null)
              Image.network(_imageUrl!, fit: BoxFit.cover),
            const SizedBox(height: 12),
            if (_category != null)
              Text(
                _category!,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            const SizedBox(height: 8),
            if (_timestamp != null)
              Text(
                'Fecha: ${_timestamp!.toDate().toLocal().toString().split(" ")[0]}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            const Divider(height: 24, thickness: 1),

            // Si hay URL externa y estamos descargando el HTML:
            if (_externalUrl != null && _externalUrl!.isNotEmpty && _fetchingHtml)
              const Center(child: CircularProgressIndicator()),

            // Si descargamos correctamente el HTML (ya sea vía Web con proxy o nativo):
            if (_externalUrl != null && _externalUrl!.isNotEmpty && _fetchedHtml != null)
              Html(data: _fetchedHtml!),

            // Si hay URL externa pero no logramos descargar el HTML:
            if (_externalUrl != null &&
                _externalUrl!.isNotEmpty &&
                !_fetchingHtml &&
                _fetchedHtml == null)
              const Text(
                'No se pudo cargar el contenido de la URL.',
                style: TextStyle(color: Colors.red),
              ),

            // Si no había URL externa, mostramos contenido plano:
            if ((_externalUrl == null || _externalUrl!.isEmpty) && _plainContent != null)
              Text(_plainContent!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
