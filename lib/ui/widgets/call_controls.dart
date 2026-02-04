import 'package:flutter/material.dart';
import '../../services/agora_service.dart';

class CallControls extends StatelessWidget {
  final AgoraService agora;

  const CallControls({super.key, required this.agora});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          backgroundColor: Colors.grey.shade800,
          onPressed: agora.switchCamera,
          child: const Icon(Icons.cameraswitch),
        ),
        const SizedBox(width: 24),
        FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            agora.leave();
            Navigator.pop(context);
          },
          child: const Icon(Icons.call_end),
        ),
      ],
    );
  }
}
