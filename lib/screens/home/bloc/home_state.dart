part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class Processing extends HomeState {}

class QrScanCompleted extends HomeState {
  final String videoUrl;
  final CustomVideoPlayerController customVideoPlayerController;
  final QRViewController controller;
  final List<File> thumbnailImages;
  QrScanCompleted(
      {required this.videoUrl,
      required this.controller,
      required this.customVideoPlayerController,
      required this.thumbnailImages});

  QrScanCompleted copyWith(
      {String? videoUrl,
      CustomVideoPlayerController? customVideoPlayerController,
      QRViewController? controller,
      List<File>? thumbnailImages}) {
    return QrScanCompleted(
        videoUrl: videoUrl ?? this.videoUrl,
        controller: controller ?? this.controller,
        customVideoPlayerController:
            customVideoPlayerController ?? this.customVideoPlayerController,
        thumbnailImages: thumbnailImages ?? this.thumbnailImages);
  }
}

class ThumbnailsLoaded extends HomeState {
  final List<File> thumbnailImages;
  final String? videoUrl;
  final CustomVideoPlayerController? customVideoPlayerController;
  final QRViewController? controller;

  ThumbnailsLoaded(
      {required this.thumbnailImages,
      this.videoUrl,
      this.controller,
      this.customVideoPlayerController});

  ThumbnailsLoaded copyWith(
      {List<File>? thumbnailImages,
      String? videoUrl,
      CustomVideoPlayerController? customVideoPlayerController,
      QRViewController? controller}) {
    return ThumbnailsLoaded(
        videoUrl: videoUrl ?? this.videoUrl,
        customVideoPlayerController:
            customVideoPlayerController ?? this.customVideoPlayerController,
        thumbnailImages: thumbnailImages ?? this.thumbnailImages,
        controller: controller ?? this.controller);
  }
}
