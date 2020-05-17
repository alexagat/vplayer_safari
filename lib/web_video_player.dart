import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WebVideoWidget extends StatefulWidget {
  const WebVideoWidget({
    Key key,
    this.src,
    this.width,
    this.height,
    this.onComplete,
    this.showControls = true,
    this.startAt = 0,
    this.autoplay = false,
    this.disabledSeeking = false,
  }) : super(key: key);

  final int width;
  final int height;
  final bool autoplay;
  final bool showControls;
  final bool disabledSeeking;
  final String src;
  final double startAt;
  final ui.VoidCallback onComplete;

  @override
  _WebVideoWidgetState createState() => _WebVideoWidgetState();
}

class _WebVideoWidgetState extends State<WebVideoWidget> {
  VideoElement video;

  double position = 0;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    ui.platformViewRegistry.registerViewFactory(widget.src, (int viewId) {
      video = VideoElement()
        ..id = 'videoPlayer${DateTime.now().millisecondsSinceEpoch}'
        ..width = widget.width
        ..height = widget.height
        ..src = widget.src
        ..autoplay = widget.autoplay
        ..controls = widget.showControls
        ..disableRemotePlayback = true
        ..style.border = 'none';
      video.attributes['controlsList'] = 'nodownload nofullscreen';
      video
        ..onPlay.listen((event) {
          if (mounted) setState(() => isPlaying = true);
        })
        ..onTimeUpdate.listen((event) {
          position = !video.seeking ? video.currentTime : position;
        });

      return video;
    });
  }

  @override
  void dispose() {
    //_log.fine('_WebVideoElementState.dispose... ');
    video?.pause();
    //video = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      /*mainAxisSize: MainAxisSize.min,*/
      children: [
        SizedBox(
          width: widget.width.toDouble(),
          height: widget.height.toDouble(),
          child: HtmlElementView(viewType: widget.src),
        ),
      ],
    );
  }
}
