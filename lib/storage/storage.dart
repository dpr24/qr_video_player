import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final Storage storage = Storage._internal();

  factory Storage() => storage;

  Storage._internal();

  final s = const FlutterSecureStorage();

  static String historyList = '_history_list';

  Future<void> storeHistoryList({required String list}) async =>
      await s.write(key: historyList, value: list);

  Future<String?> getHistoryList() async => await s.read(key: historyList);
}
