import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_video_player/screens/home/bloc/home_bloc.dart';

class HistoryWidget extends StatefulWidget {
  final List<File> thumbnailImages;

  const HistoryWidget({super.key, required this.thumbnailImages});

  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  bool fullScreen = false;
  bool isExpanded = true;
  bool mini = false;

  ExpansionTileController? expansionTileController = ExpansionTileController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: mini
          ? MediaQuery.of(context).size.width / 2
          : MediaQuery.of(context).size.width,
      child: mini
          ? GestureDetector(
              onTap: () {
                setState(() {
                  mini = false;
                });
              },
              child: Center(
                child: Hero(
                  tag: 'history',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: !mini ? 80 : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal.withOpacity(0.1)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "History",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  color:
                      fullScreen ? Colors.white : Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  controller: expansionTileController,
                  initiallyExpanded: true,
                  title: SizedBox(
                    // width: fullScreen ? 80 : 50,
                    height: fullScreen ? 50 : 30,
                    child: const Hero(
                      tag: 'history',
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        // fit: BoxFit.scaleDown,
                        child: Text(
                          "History",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                  trailing: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (expansionTileController!.isExpanded) {
                                  isExpanded = !isExpanded;
                                  expansionTileController!.collapse();
                                } else {
                                  expansionTileController!.expand();
                                  isExpanded = !isExpanded;
                                  
                                }
                              });
                            },
                            icon: Icon(
                              isExpanded
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: Colors.teal,
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                mini = true;
                              });
                            },
                            icon: const Icon(
                              Icons.minimize_rounded,
                              color: Colors.teal,
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                fullScreen = !fullScreen;
                              });
                            },
                            icon: Icon(
                              fullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.teal,
                            )),
                      ],
                    ),
                  ),
                  children: [
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          // width: MediaQuery.of(context).size.width,
                          height: fullScreen
                              ? MediaQuery.of(context).size.height / 1.3
                              : 100,

                          child: fullScreen
                              ? GridView.builder(
                                  itemCount: widget.thumbnailImages.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 3 / 1.8),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            // height: 100,
                                            // width: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                widget.thumbnailImages[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            //   top: 0,
                                            //  // bottom: 10,
                                            //   left: 0,
                                            //   right: 0,
                                            child: IconButton(
                                              onPressed: () {
                                                context.read<HomeBloc>().add(
                                                    ThumbnailImageClicked(
                                                        thumbnailFile: widget
                                                                .thumbnailImages[
                                                            index],
                                                        context: context));
                                              },
                                              icon: Icon(
                                                CupertinoIcons.play_arrow,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                              iconSize: 15,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            // bottom: 10,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.black12,
                                                        Colors.black26,
                                                        Colors.black38,
                                                        Colors.black87,
                                                        Colors.black,
                                                        Colors.black
                                                      ])),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  widget.thumbnailImages[index]
                                                      .path
                                                      .split('/')
                                                      .last
                                                      .split('.')
                                                      .first,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white
                                                          .withOpacity(0.5)),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.thumbnailImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 90,
                                            // width: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                widget.thumbnailImages[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: IconButton(
                                              onPressed: () {
                                                context.read<HomeBloc>().add(
                                                    ThumbnailImageClicked(
                                                        thumbnailFile: widget
                                                                .thumbnailImages[
                                                            index],
                                                        context: context));
                                              },
                                              icon: Icon(
                                                CupertinoIcons.play_arrow,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                              iconSize: 15,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 2,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Colors.black12,
                                                    Colors.black26,
                                                    Colors.black38,
                                                    Colors.black87,
                                                    Colors.black,
                                                    Colors.black
                                                  ])),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  widget.thumbnailImages[index]
                                                      .path
                                                      .split('/')
                                                      .last
                                                      .split('.')
                                                      .first,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white
                                                          .withOpacity(0.5)),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
