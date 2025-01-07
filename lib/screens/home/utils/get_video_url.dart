import 'package:qr_video_player/history/history_manager.dart';

class GetVideoUrl {
  static Future<String?> getVideoUrl(String path) async {
    final historyManager = HistoryManager();

    for (var url in historyManager.historyList) {
      if (url.contains(path.split('/').last.replaceAll('.jpg', '.mp4'))) {
        return url;
      }
    }
    return null;
  }
}
