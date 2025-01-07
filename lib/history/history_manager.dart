import 'dart:convert';

import 'package:qr_video_player/storage/storage.dart';

class HistoryManager {
  List<String> historyList = [];

  static final HistoryManager _instance = HistoryManager._internal();

  HistoryManager._internal();

  factory HistoryManager() {
    return _instance;
  }

  Future<void> storeHistory() async {
    final historyjson = jsonEncode(historyList);
    await Storage().storeHistoryList(list: historyjson).then((v) {
      print('history stored');
    });
  }

  Future<void> loadHistory() async {
    try {
      final historyString = await Storage().getHistoryList();

      historyList = List<String>.from(jsonDecode(historyString!));
    } catch (e) {
      print(e);
    }
    print('history list : $historyList');
  }

  addToHistory({required String url}) async {
    if (!historyList.contains(url)) {
      historyList.add(url);
    }
  }
}
