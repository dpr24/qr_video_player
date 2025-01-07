part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class QrCodeScanned extends HomeEvent {
  // final QRViewController controller;
  // final BuildContext context;
  final String url;
  QrCodeScanned({required this.url});
}

class ClearAll extends HomeEvent {
  final QRViewController controller;
  final CustomVideoPlayerController videoPlayerController;

  ClearAll({required this.controller, required this.videoPlayerController});
}

class LoadThumbnails extends HomeEvent {}

class ThumbnailImageClicked extends HomeEvent {
  final File thumbnailFile;
  final BuildContext context;
  ThumbnailImageClicked({required this.thumbnailFile, required this.context});
}
