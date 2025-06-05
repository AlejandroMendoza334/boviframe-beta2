import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsDetailScreen extends StatefulWidget {
  final String documentId;

  const NewsDetailScreen({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _loading = true;
  String? _title;
  String? _imageUrl;
  String? _category;
  DateTime? _date;
  String _plainContent = '';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('news')
        .doc(widget.documentId)
        .get();

    if (!mounted) return;

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      final String plainText = data['content'] as String? ?? '';

      setState(() {
        _title        = data['title'] as String?;
        _imageUrl     = data['imageUrl'] as String?;
        _category     = data['category'] as String?;
        _date         = (data['date'] as Timestamp).toDate();
        _plainContent = plainText;
        _loading      = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cargando…'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_title == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Noticia no encontrada'),
          backgroundColor: Colors.blue[800],
        ),
        body: const Center(child: Text('La noticia solicitada no existe.')),
      );
    }

    String formattedDate = '';
    if (_date != null) {
      formattedDate =
          '${_date!.day.toString().padLeft(2, '0')}/'
          '${_date!.month.toString().padLeft(2, '0')}/'
          '${_date!.year}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title!),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_imageUrl != null && _imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(_imageUrl!),
              ),
              const SizedBox(height: 12),
            ],

            if (_category != null && _category!.isNotEmpty) ...[
              Text(
                _category!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
            ],

            if (formattedDate.isNotEmpty) ...[
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
            ],

            Text(
              _plainContent,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
