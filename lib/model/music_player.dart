import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  MusicPlayer({this.songInfo});
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.music_note, color: Colors.black)),
        title: Text(
          'Now Playing',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
        child: Column(children: <Widget>[
          CircleAvatar(
                backgroundImage: widget.songInfo.albumArtwork == null
                    ? AssetImage('assets/image/revolt.jpg')
                    : FileImage(File(widget.songInfo.albumArtwork)),
                    radius: 95,
              ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(widget.songInfo.title),
          )
        ],),
      )
    );
  }
}