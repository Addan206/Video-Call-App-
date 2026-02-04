import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/agora_config.dart';

class AgoraService {
  RtcEngine? engine;
  int? remoteUid;

  Future<void> init() async {
    await _requestPermissions();
    await _createEngine();
    await _joinChannel();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  Future<void> _createEngine() async {
    engine = createAgoraRtcEngine();

    await engine!.initialize(
      RtcEngineContext(appId: AgoraConfig.appId),
    );

    await engine!.enableVideo();
    await engine!.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (_, uid, __) {
          remoteUid = uid;
        },
        onUserOffline: (_, __, ___) {
          remoteUid = null;
        },
      ),
    );

    await engine!.startPreview();
  }

  Future<void> _joinChannel() async {
    await engine!.joinChannel(
      token: AgoraConfig.token,
      channelId: AgoraConfig.channelName,
      uid: AgoraConfig.localUid,
      options: const ChannelMediaOptions(
        channelProfile:
        ChannelProfileType.channelProfileCommunication,
        clientRoleType:
        ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  void switchCamera() => engine?.switchCamera();

  Future<void> leave() async {
    await engine?.leaveChannel();
    await engine?.release();
    engine = null;
  }
}
