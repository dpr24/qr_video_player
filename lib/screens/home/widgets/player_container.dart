import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_video_player/screens/home/bloc/home_bloc.dart';

class PlayerContainer extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final QRViewController qrViewController;
  const PlayerContainer(
      {super.key,
      required this.qrViewController,
      required this.customVideoPlayerController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: CustomVideoPlayer(
                customVideoPlayerController: customVideoPlayerController,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  print('icon');
                  context.read<HomeBloc>().add(ClearAll(
                      controller: qrViewController,
                      videoPlayerController: customVideoPlayerController));
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
