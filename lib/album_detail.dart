// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class AlbumDetailPage extends StatefulWidget {
  final Map<String, dynamic> albumData;

  const AlbumDetailPage({super.key, required this.albumData});

  @override
  _AlbumDetailPageState createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumData['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(widget.albumData['cover_big']),
            SizedBox(height: 20),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Album: ${widget.albumData['title']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Release Date: ${widget.albumData['release_date']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _isDownloading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isDownloading = true;
                      });
                      await _downloadImage();
                      setState(() {
                        _isDownloading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadImage() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final downloadDirectory = Directory('${directory.path}/Download');
      await downloadDirectory
          .create(); // Create the directory if it doesn't exist

      final filename =
          '${DateTime.now().millisecondsSinceEpoch}${widget.albumData['cover_big'].split('/').last}';
      final file = File('${downloadDirectory.path}/$filename');

      final response = await http.get(Uri.parse(widget.albumData['cover_big']));
      final bytes = response.bodyBytes;

      await file.writeAsBytes(bytes);

      // Show a SnackBar notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image downloaded successfully'),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Open Folder',
            onPressed: () async {
              await OpenFile.open(downloadDirectory.path);
            },
          ),
        ),
      );
    } else {
      // Handle the case where the external storage is not available
      print('External storage is not available');
    }
  }
}
