import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../services/agora_service.dart';
import '../../core/agora_config.dart';

class RemoteVideoView extends StatelessWidget {
  final AgoraService agora;

  const RemoteVideoView({super.key, required this.agora});

  @override
  Widget build(BuildContext context) {
    if (agora.engine == null || agora.remoteUid == null) {
      return const Center(
        child: Text(
          "Waiting for another user...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: agora.engine!,
        canvas: VideoCanvas(uid: agora.remoteUid),
        connection: const RtcConnection(
          channelId: AgoraConfig.channelName,
        ),
      ),
    );
  }
}
