import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

class ThumbnailGenerator {
  static final ThumbnailGenerator _instance = ThumbnailGenerator._internal();

  factory ThumbnailGenerator() {
    return _instance;
  }

  ThumbnailGenerator._internal() {
    print('ThumbnailGenerator instance created');
  }

  final Map<String, File> thumbnailCache = {};

  Future<void> generateThumbnail(List<String> videoPaths) async {
    final tempDir = await getTemporaryDirectory();

    for (String videoPath in videoPaths) {
      final thumbnailPath =
          '${tempDir.path}/${videoPath.split('/').last.replaceAll('.mp4', '')}.jpg';

      if (!File(thumbnailPath).existsSync()) {
        final ffmpegCommand =
            '-i "$videoPath" -ss 00:00:01 -vframes 1 -q:v 2 "$thumbnailPath"';

        await FFmpegKit.execute(ffmpegCommand);
      }

      thumbnailCache[videoPath] = File(thumbnailPath);
    }

    final dir = await getTemporaryDirectory();
    final l = dir.listSync();
    print(l);
  }

  File? getThumbnail(String videoPath) {
    return thumbnailCache[videoPath];
  }

  Future<List<File>> generateThumbnailsForVideo(List<String> videoPaths) async {
    await generateThumbnail(videoPaths);
    List<File> thumbnailFiles = [];

    for (String path in videoPaths) {
      final thumbnail = getThumbnail(path);
      thumbnailFiles.add(thumbnail!);
    }

    return thumbnailFiles;
  }
}
