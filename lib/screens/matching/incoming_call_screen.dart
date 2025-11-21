import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callId;
  final String callerName;

  IncomingCallScreen({required this.callId, required this.callerName});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playRingtone();
    _vibratePhone();
  }

  void _playRingtone() async {
    await player.setAsset('assets/sounds/ringtone.mp3');
    player.setLoopMode(LoopMode.one);
    player.play();
  }

  void _vibratePhone() {
    Vibration.vibrate(pattern: [0, 1000, 500, 1000], repeat: 0);
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  void _acceptCall() {
    player.stop();

    Navigator.pop(context);

    // TODO: Lancer ZegoUIKitPrebuiltCall
  }

  void _rejectCall() {
    player.stop();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.callerName,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 20),
            Text("Appel entrant", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.call_end),
                  onPressed: _rejectCall,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.call),
                  onPressed: _acceptCall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
