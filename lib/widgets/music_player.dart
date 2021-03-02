import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'music_image.dart';
import 'package:audio_manager/audio_manager.dart';
import 'volume.dart';
import 'dart:io';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  Function changeSong;

  final GlobalKey<MusicPlayerState> key;
  MusicPlayer({this.songInfo, this.changeSong, this.key}) : super(key: key);
  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double minimumValue = 0.0;
  double maximumValue = 10.0;
  double currentValue = 0.0;
  String currentTime = '';
  String endTime = '';

  bool isPlaying = false;
  AudioManager audioManager;

  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    setSong(widget.songInfo);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    player?.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((event) {
      currentValue = event.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);

        if (currentTime == endTime) {
          //player.seekToNext();
          widget.changeSong(true);
          //audioManager.next();
          //player.seekToNext();
          //audioManager.next();
        }
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: deviceHeight,
            width: deviceWidth,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: widget.songInfo.albumArtwork == null
                      ? AssetImage('assets/image/revolt.jpg')
                      : FileImage(File(widget.songInfo.albumArtwork)),
                  fit: BoxFit.fill),
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 2.0,
                    spreadRadius: 1.0,
                    offset: Offset(2, 3))
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0),
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          //margin: EdgeInsets.fromLTRB(5, 5, 5, 0),

          Container(
            margin: EdgeInsets.only(top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                musicImage(widget.songInfo),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: widget.songInfo.title.endsWith('.com')
                      ? Text(widget.songInfo.title.replaceAll('.com', ''),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600))
                      : Text(widget.songInfo.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Text(
                    widget.songInfo.artist,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Slider(
                    value: currentValue.toDouble() > maximumValue
                        ? maximumValue
                        : currentValue.toDouble(),
                    onChanged: (double newValue) {
                      setState(() {
                        currentValue = newValue;
                        player
                            .seek(Duration(milliseconds: currentValue.round()));
                      });
                    },
                    inactiveColor: Colors.black12,
                    activeColor: Colors.blueGrey,
                    min: 0.0,
                    max: maximumValue),
                Container(
                  transform: Matrix4.translationValues(0, -7, 0),
                  margin: EdgeInsets.only(top: 3, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentTime,
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        endTime,
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.skip_previous,
                            color: Colors.black, size: 45),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          widget.changeSong(false);
                        },
                      ),
                      GestureDetector(
                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.black, size: 45),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.black, size: 45);
                          changeStatus();
                        },
                      ),
                      GestureDetector(
                        child: Icon(Icons.skip_next,
                            color: Colors.black, size: 45),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          widget.changeSong(true);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.volume_up,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          AudioManager.instance.setVolume(0);
                        },
                      ),
                      Expanded(
                        child: Volume(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
