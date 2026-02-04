import 'package:flutter/material.dart';
import '../services/agora_service.dart';
import 'widgets/local_video_view.dart';
import 'widgets/remote_video_view.dart';
import 'widgets/call_controls.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final AgoraService _agora = AgoraService();
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _agora.init();
    setState(() => _ready = true);
  }

  @override
  void dispose() {
    _agora.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RemoteVideoView(agora: _agora),

          Positioned(
            right: 16,
            bottom: 110,
            width: 120,
            height: 160,
            child: LocalVideoView(agora: _agora),
          ),

          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: CallControls(agora: _agora),
          ),
        ],
      ),
    );
  }
}
