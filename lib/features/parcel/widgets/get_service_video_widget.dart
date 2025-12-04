import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GetServiceVideoWidget extends StatefulWidget {
  final String youtubeVideoUrl;
  final String fileVideoUrl;
  const GetServiceVideoWidget({super.key, required this.youtubeVideoUrl, required this.fileVideoUrl});

  @override
  State<GetServiceVideoWidget> createState() => _GetServiceVideoWidgetState();
}

class _GetServiceVideoWidgetState extends State<GetServiceVideoWidget> {

  YoutubePlayerController? _controller;
  VideoPlayerController? _videoPlayerController;
  bool _isYoutubeVideo = false;

  @override
  void initState() {
    super.initState();

    String url = widget.youtubeVideoUrl;
    if(url.isNotEmpty) {
      _isYoutubeVideo = true;

      String? convertedUrl = YoutubePlayerController.convertUrlToId(url);

      if (convertedUrl != null) {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: convertedUrl,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            mute: false,
            loop: false,
            enableCaption: false,
            showVideoAnnotations: false,
            showFullscreenButton: false,
          ),
        );
      }
    } else if(widget.fileVideoUrl.isNotEmpty){
      _isYoutubeVideo = false;
      configureForMp4(widget.fileVideoUrl);
    }
  }

  void configureForMp4(String videoUrl) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    _videoPlayerController?.play();
    _videoPlayerController?.setVolume(0);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _videoPlayerController != null) {
        _videoPlayerController?.pause();
        _videoPlayerController?.setVolume(1);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller?.close();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isYoutubeVideo && _controller != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: YoutubePlayer(
          controller: _controller!,
          backgroundColor: Colors.transparent,
        ),
      );
    } else if (!_isYoutubeVideo && _videoPlayerController != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: _videoPlayerController!.value.isInitialized
                ? AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController!),
            )
                : const SizedBox(),
          ),

          _videoPlayerController!.value.isInitialized
              ? Positioned(
            bottom: 10,
            left: 20,
            child: InkWell(
              onTap: (){
                if (mounted) {
                  setState(() {
                    _videoPlayerController!.value.isPlaying ? _videoPlayerController!.pause() : _videoPlayerController!.play();
                  });
                }
              },
              child: Icon(
                _videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 34,
              ),
            ),
          )
              : const SizedBox(),
        ],
      );
    }

    return const SizedBox();
  }
}