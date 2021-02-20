import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'music_player.dart';
import 'package:just_audio/just_audio.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  int currentIndex = 0;
  double currentTime = 0.0;
  double endTime = 0.0;
  double maximumValue;

  final AudioPlayer player = AudioPlayer();

  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
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

  

  void changeSongs(bool isNext){
    
    if(isNext){
      if(currentIndex != songs.length - 1){
        currentIndex++;
      }
    }else{
      if(currentIndex != 0){
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Icon(Icons.music_note, color: Colors.black),
        title: Text(
          'Playlist',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: songs[index].albumArtwork == null
                    ? AssetImage('assets/image/revolt.jpg')
                    : FileImage(File(songs[index].albumArtwork)),
              ),
              title: songs[index].title.endsWith('.com') ? Text(songs[index].title.replaceAll('.com', '')) : Text(songs[index].title),
              subtitle: Text(songs[index].artist),
              onTap: () {
                currentIndex = index;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MusicPlayer(
                      changeSong: changeSongs,
                      songInfo: songs[currentIndex],
                      
                      key: key,
                    ),
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: songs.length),
    );
  }
}
