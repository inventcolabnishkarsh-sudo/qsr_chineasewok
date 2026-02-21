import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PromoVideoBox extends StatefulWidget {
  const PromoVideoBox({super.key});

  @override
  State<PromoVideoBox> createState() => _PromoVideoBoxState();
}

class _PromoVideoBoxState extends State<PromoVideoBox> {
  late final VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _videoController.play();
  }

  @override
  void deactivate() {
    _videoController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/videos/promo.mp4');

    _videoController.initialize().then((_) {
      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false, // ❌ don't auto play on rebuild
        looping: true,
        showControls: false,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false,
        aspectRatio: 16 / 9,
      );

      _videoController.play(); // ✅ controlled start

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity, // ✅ full width
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9, // 🔥 clean promo ratio
        child: _chewieController == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Chewie(controller: _chewieController!),
      ),
    );
  }
}
