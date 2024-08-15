// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:album_art_finder/deezer_api_service.dart';
import 'package:album_art_finder/album_detail.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController artistController = TextEditingController();
  final TextEditingController albumController = TextEditingController();
  final DeezerApiService apiService = DeezerApiService();
  List<Map<String, dynamic>> albums = [];
  bool _isLoading = false;
  // PanelController _panelController = PanelController();

  void _resetFunction() {
    artistController.clear();
    albumController.clear();
    setState(() {
      albums = [];
    });
  }

  Future<void> _searchAlbums() async {
    setState(() {
      _isLoading = true;
    });
    final artistName = artistController.text;
    final albumName = albumController.text;

    if (albumName.isNotEmpty) {
      final albumData = await apiService.searchAlbumsByName(albumName);
      setState(() {
        albums = albumData;
        _isLoading = false;
      });
    } else if (artistName.isNotEmpty) {
      final artistsData = await apiService.searchArtistsByName(artistName);
      List<Map<String, dynamic>> fetchedAlbums = [];
      for (var artist in artistsData) {
        final artistId = artist['id'];
        final albumData = await apiService.fetchArtistAlbums(artistId);
        fetchedAlbums.addAll(albumData);
      }
      setState(() {
        albums = fetchedAlbums;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Album Art Finder',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Using Deezer API',
                            style: TextStyle(color: Colors.blue[200]),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _resetFunction();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.all(12),
                          minimumSize: Size(40, 40),
                        ),
                        child: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            controller: artistController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Artist',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            controller: albumController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Album',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fill one of the text box',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _searchAlbums();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 25,
                  // ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Container(
                  color: Colors.white,
                  child: albums.isEmpty
                      ? Container(
                          // alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 64.0,
                            vertical: 128.0,
                          ),
                          child: const Text(
                            'Please enter an artist name or album name to start searching.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 24.0,
                            left: 24.0,
                            right: 24.0,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0),
                            itemCount: albums.length,
                            itemBuilder: (context, index) {
                              final album = albums[index];
                              return Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AlbumDetailPage(
                                          albumData: album,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: album['cover_medium'] != null
                                        ? Image.network(
                                            album['cover_medium'],
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Text('Image not available'),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
