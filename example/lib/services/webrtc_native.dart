import 'dart:io';

import 'package:flutter/services.dart';

class WebRTCNative {
  static const String webRTCChannel = 'rana_channel';

  final MethodChannel _ranaChannel = MethodChannel(webRTCChannel);

  Future<void> createPipVideoCall({
    required String remoteStreamId,
    required String peerConnectionId,
    String myAvatar = "https://avatars.githubusercontent.com/u/60530946?v=4",
    bool isRemoteCameraEnable = true,
  }) async {
    if (!Platform.isIOS) return;

    _ranaChannel.invokeMethod("createPiP", {
      "remoteStreamId": remoteStreamId,
      "peerConnectionId": peerConnectionId,
      "isRemoteCameraEnable": isRemoteCameraEnable,
      "myAvatar": myAvatar,
    });
  }

  Future<void> disposePiP() async {
    await _ranaChannel.invokeMethod("disposePiP");
  }
}
