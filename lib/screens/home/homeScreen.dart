import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_video_player/constants/app_texts.dart';
import 'package:qr_video_player/qr_controller/qr_controller.dart';
import 'package:qr_video_player/screens/home/bloc/home_bloc.dart';
import 'package:qr_video_player/screens/home/widgets/history_widget.dart';
import 'package:qr_video_player/screens/home/widgets/loading_widget.dart';
import 'package:qr_video_player/screens/home/widgets/player_container.dart';
import 'package:qr_video_player/video_player/video_player_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final qrController = QrController();
  Offset videoPosition = const Offset(40, 370);
  final videoPlayerManager = VideoPlayerManager();
  bool allowBack = false;
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadThumbnails());

    videoPlayerManager.initialize(context: context);
    checkCameraPermission();
  }

  Future<void> checkCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      // Permission is granted
    } else {
      // Permission denied
    }
  }

  void _onQrCreated(QRViewController controller) async {
    qrController.setController(controller: controller);

    controller.scannedDataStream.listen((val) async {
      if (val.code != null && val.code!.contains('.mp4')) {
        if (mounted) {
          context
              .read<HomeBloc>()
              .add(QrCodeScanned(url: val.code!.replaceAll('http', 'https')));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.cyanAccent,
            title: const Text(
              AppTexts.appName,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: const [],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      if (qrController.qrViewController != null) {
                        qrController.qrViewController!.toggleFlash();
                      }
                    });
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 50,
                    child: QRView(
                      key: qrKey,
                      overlay: QrScannerOverlayShape(
                          borderRadius: 15,
                          borderWidth: 15,
                          borderColor: Theme.of(context).primaryColor),
                      onQRViewCreated: _onQrCreated,
                    ),
                  ),
                ),
                if (state is Processing) ...[const LoadingWidget()],
                if (qrController.qrViewController != null)
                  Positioned(
                      bottom: MediaQuery.of(context).size.height / 3.4,
                      right: MediaQuery.of(context).size.width / 15,
                      child: FutureBuilder(
                        future: qrController.qrViewController!.getFlashStatus(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool?> snapshot) {
                          if (snapshot.hasData) {
                            return IconButton(
                                onPressed: () async {
                                  setState(() {
                                    qrController.qrViewController!
                                        .toggleFlash();
                                  });
                                },
                                icon: Icon(
                                  snapshot.data!
                                      ? CupertinoIcons.lightbulb_slash
                                      : CupertinoIcons.lightbulb_fill,
                                  color: Colors.teal,
                                ));
                          } else {
                            return const SizedBox();
                          }
                        },
                      )),
                if (state is QrScanCompleted) ...[
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: HistoryWidget(
                              thumbnailImages: state.thumbnailImages))),
                  if (state.videoUrl.isNotEmpty)
                    Positioned(
                      left: videoPosition.dx,
                      top: videoPosition.dy,
                      child: Draggable(
                        feedback: Material(
                          color: Colors.transparent,
                          child: PlayerContainer(
                              qrViewController: state.controller,
                              customVideoPlayerController:
                                  state.customVideoPlayerController),
                        ),
                        childWhenDragging: Container(),
                        child: PlayerContainer(
                            qrViewController: state.controller,
                            customVideoPlayerController:
                                state.customVideoPlayerController),
                        onDragEnd: (details) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight =
                              MediaQuery.of(context).size.height;
                          const videoWidth = 380.0;
                          const videoHeight = 500.0;
                          setState(() {
                            videoPosition = Offset(
                              (details.offset.dx + 10)
                                  .clamp(0, screenWidth - videoWidth),
                              (details.offset.dy - 100)
                                  .clamp(0, screenHeight - videoHeight),
                            );
                          });
                          print(details.offset);
                        },
                      ),
                    ),
                ],
                // if (state is ThumbnailsLoaded) ...[
                // Positioned(
                //     bottom: 0,
                //     left: 0,
                //     right: 0,
                //     child: Center(
                //         child: HistoryWidget(
                //             thumbnailImages: state.thumbnailImages)))
                //  ],
              ],
            ),
          ),
        );
      },
    );
  }
}
