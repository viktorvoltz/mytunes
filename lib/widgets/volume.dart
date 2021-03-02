import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/services.dart';

class Volume extends StatefulWidget {
  @override
  _VolumeState createState() => _VolumeState();
}

class _VolumeState extends State<Volume> {
  AudioManager audioManager;
  double _sliderVolume;
  double currentVolume;
  double min;
  double max ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.black,
          inactiveTrackColor: Colors.grey,
          thumbColor: Colors.black,
          
          trackHeight: 1.5,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
        ),
        child: Slider(
          value: _sliderVolume ?? 0,
          onChanged: (double newValue){
            _sliderVolume = newValue;
            AudioManager.instance.setVolume(newValue, showVolume: true);
          },

        ),
      ),
    );
  }
}