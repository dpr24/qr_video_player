import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerManager {
  CustomVideoPlayerController? playerController;
  BuildContext? _context;

  static final VideoPlayerManager _videoPlayerManager =
      VideoPlayerManager._internal();

  VideoPlayerManager._internal();

  factory VideoPlayerManager() {
    return _videoPlayerManager;
  }

  Future<void> initialize({required context, String? url}) async {
    _context = context;

    playerController = CustomVideoPlayerController(
      customVideoPlayerSettings:
          const CustomVideoPlayerSettings(customAspectRatio: 3 / 1),
      context: context,
      videoPlayerController: CachedVideoPlayerController.network(url ?? ""),
    );
    await playerController!.videoPlayerController.initialize();

    print('video player init');
  }

  Future<CustomVideoPlayerController> getPlayerController(
      {required String url}) async {
    if (playerController != null) {
      playerController!.videoPlayerController.dispose();
    }
    playerController = CustomVideoPlayerController(
      customVideoPlayerSettings:
          const CustomVideoPlayerSettings(customAspectRatio: 3 / 1),
      context: _context!,
      videoPlayerController: CachedVideoPlayerController.network(url),
    );
    await playerController!.videoPlayerController.initialize();

    return playerController!;
  }
}
