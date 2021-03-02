import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
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
            fit: BoxFit.fill),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
              color: Colors.black54,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(2, 3))
        ],
        borderRadius: BorderRadius.circular(5)),
  );
}
