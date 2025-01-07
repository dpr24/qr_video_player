import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_video_player/history/history_manager.dart';
import 'package:qr_video_player/qr_controller/qr_controller.dart';
import 'package:qr_video_player/screens/home/utils/get_video_url.dart';
import 'package:qr_video_player/screens/home/utils/thumbnail_generator.dart';
import 'package:qr_video_player/video_player/video_player_manager.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final historyManager = HistoryManager();
  final qrController = QrController();
  final videoPlayerManager = VideoPlayerManager();
  final thumbnailGenerator = ThumbnailGenerator();

  HomeBloc() : super(HomeInitial()) {
    on<LoadThumbnails>((event, emit) async {
      print('LoadThumbnails event triggered');
      final thumbnailGenerator = ThumbnailGenerator();
      await historyManager.loadHistory();
      //  if (historyManager.historyList.isNotEmpty) {
      final thumbnailImages = await thumbnailGenerator
          .generateThumbnailsForVideo(historyManager.historyList);
      // emit(ThumbnailsLoaded(thumbnailImages: thumbnailImages));
      emit(QrScanCompleted(
          videoUrl: '',
          controller: qrController.qrViewController!,
          customVideoPlayerController: videoPlayerManager.playerController!,
          thumbnailImages: thumbnailImages));
      // } else {
      //   // emit(ThumbnailsLoaded(thumbnailImages: const []));
      //   emit(QrScanCompleted(
      //       videoUrl: '',
      //       controller: qrController.qrViewController!,
      //       customVideoPlayerController: videoPlayerManager.playerController!,
      //       thumbnailImages: const []));
      // }
    });

    on<QrCodeScanned>((event, emit) async {
      await qrController.qrViewController!.pauseCamera();
      emit(Processing());

      final playerController =
          await videoPlayerManager.getPlayerController(url: event.url);

      // if (state is ThumbnailsLoaded) {
      //   final thumbnailState = state as ThumbnailsLoaded;
      //   historyManager.addToHistory(url: event.url);
      //   emit(QrScanCompleted(
      //       videoUrl: event.url,
      //       customVideoPlayerController: playerController,
      //       controller: qrController.qrViewController!,
      //       thumbnailImages: thumbnailState.thumbnailImages));
      // } else {
      //   final thumbnailImages = await thumbnailGenerator
      //       .generateThumbnailsForVideo(historyManager.historyList);

      //   historyManager.addToHistory(url: event.url);
      //   emit(QrScanCompleted(
      //       videoUrl: event.url,
      //       customVideoPlayerController: playerController,
      //       controller: qrController.qrViewController!,
      //       thumbnailImages: thumbnailImages));
      // }
      historyManager.addToHistory(url: event.url);
      final thumbnailImages = await thumbnailGenerator
          .generateThumbnailsForVideo(historyManager.historyList);

      emit(QrScanCompleted(
          videoUrl: event.url,
          customVideoPlayerController: playerController,
          controller: qrController.qrViewController!,
          thumbnailImages: thumbnailImages));
    });

    on<ClearAll>((event, emit) async {
      videoPlayerManager.playerController!.dispose();
      qrController.qrViewController!.resumeCamera();

      await historyManager.storeHistory();

      final newstate = state as QrScanCompleted;

      // emit(ThumbnailsLoaded(
      //     thumbnailImages: newstate.thumbnailImages,
      //     videoUrl: '',
      //     controller: event.controller,
      //     customVideoPlayerController: event.videoPlayerController));
      emit(QrScanCompleted(
          videoUrl: '',
          controller: newstate.controller,
          customVideoPlayerController: newstate.customVideoPlayerController,
          thumbnailImages: newstate.thumbnailImages));

      await thumbnailGenerator
          .generateThumbnailsForVideo(historyManager.historyList)
          .then((imagesfiles) {
        // emit(ThumbnailsLoaded(
        //     thumbnailImages: imagesfiles,
        //     videoUrl: '',
        //     controller: event.controller,
        //     customVideoPlayerController: event.videoPlayerController));
        emit(QrScanCompleted(
            videoUrl: '',
            controller: newstate.controller,
            customVideoPlayerController: newstate.customVideoPlayerController,
            thumbnailImages: imagesfiles));
      });
    });

    on<ThumbnailImageClicked>((event, emit) async {
      print('ThumbnailImageClicked');

      qrController.qrViewController!.pauseCamera();

      print('file path : ${event.thumbnailFile.path}');
      print(historyManager.historyList);
      final url = await GetVideoUrl.getVideoUrl(event.thumbnailFile.path);
      print('video url : $url');
      if (url != null) {
        final playerController =
            await videoPlayerManager.getPlayerController(url: url);
        final newState = state as QrScanCompleted;
        emit(QrScanCompleted(
            videoUrl: url,
            controller: qrController.qrViewController!,
            customVideoPlayerController: playerController,
            thumbnailImages: newState.thumbnailImages));
      }
    });
  }
}
