import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoCallPage(),
    );
  }
}

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _ready = false;

  // CHANGE PER DEVICE
  final int localUid = 1; // Phone 1 = 1, Phone 2 = 2
  final String appId = "ffc0a7a6084d4685b989becf1ccfa798";
  final String token = "007eJxTYJh4dP85IY1Wd9m4ZOMbb2cW/q51NpyZm77185N1U/dv2HtIgSEtLdkg0TzRzMDCJMXEzMI0ydLCMik1Oc0wOTkt0dzS4v+emsyGQEaGlYmVrIwMEAjiszOUpBaXGBoZMzAAAI+ZI7Q=";
  final String channelName = "test123";

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();

    _engine = createAgoraRtcEngine();

    await _engine!.initialize(
      RtcEngineContext(appId: appId),
    );

    await _engine!.enableVideo();
    await _engine!.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );

    await _engine!.startPreview();

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, uid, elapsed) {
          setState(() => _remoteUid = uid);
        },
        onUserOffline: (connection, uid, reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: localUid,
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );

    setState(() => _ready = true);
  }

  void switchCamera() async {
    await _engine?.switchCamera();
  }

  void endCall() async {
    await _engine?.leaveChannel();
    await _engine?.release();
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  Widget localView() {
    if (_engine == null) return const SizedBox();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: localUid),
        ),
      ),
    );
  }

  Widget remoteView() {
    if (_engine == null || _remoteUid == null) {
      return const Center(
        child: Text(
          "Waiting for another user...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: RtcConnection(channelId: channelName),
      ),
    );
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
          Positioned.fill(child: remoteView()),

          Positioned(
            right: 16,
            bottom: 110,
            width: 120,
            height: 160,
            child: localView(),
          ),

          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "switch",
                  backgroundColor: Colors.grey.shade800,
                  onPressed: switchCamera,
                  child: const Icon(Icons.cameraswitch),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: "end",
                  backgroundColor: Colors.red,
                  onPressed: endCall,
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
