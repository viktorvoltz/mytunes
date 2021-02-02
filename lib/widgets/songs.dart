import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  int currentIndex = 0;
  @override
  void initState() {
    getTracks();
    super.initState();
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.music_note, color: Colors.black),
        title: Text(
          'Music App',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            ListTile(
              leading: CircleAvatar(
                backgroundImage: songs[index].albumArtwork == null
                    ? AssetImage('assets/image/revolt.jpg')
                    : FileImage(File(songs[index].albumArtwork)),
                    
              ),
              title: Text(songs[index].title),
              subtitle: Text(songs[index].artist),
              onTap: (){},
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: songs.length),
    );
  }
}
