import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

Widget musicImage(SongInfo songInfo) {
  return Container(
    height: 270,
    width: 300,
    decoration: new BoxDecoration(
        image: new DecorationImage(
            image: songInfo.albumArtwork == null
                ? AssetImage('assets/image/revolt.jpg')
                : FileImage(File(songInfo.albumArtwork)),
            fit: BoxFit.fill
            ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5)),
  );
}
