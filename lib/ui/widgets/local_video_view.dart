import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../services/agora_service.dart';
import '../../core/agora_config.dart';

class LocalVideoView extends StatelessWidget {
  final AgoraService agora;

  const LocalVideoView({super.key, required this.agora});

  @override
  Widget build(BuildContext context) {
    if (agora.engine == null) return const SizedBox();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agora.engine!,
          canvas:
          const VideoCanvas(uid: AgoraConfig.localUid),
        ),
      ),
    );
  }
}
