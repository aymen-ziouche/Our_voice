import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:our_voice/modules/comment.dart';
import 'package:our_voice/providers/ownerProvider.dart';
import 'package:our_voice/screens/recording/pageManager.dart';
import 'package:our_voice/widgets/canvasViewWidget.dart';
import 'package:our_voice/widgets/ownerWidget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CommentsViewWidget extends StatelessWidget {
  final Comment comment;

  const CommentsViewWidget({
    super.key,
    required this.comment,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 5,
                  offset: const Offset(1, 1))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangeNotifierProvider(
                create: (context) => OwnerProvider(comment.commentor),
                child: const OwnerWidget()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 80.w,
                    child: ValueListenableBuilder<ProgressBarState>(
                      valueListenable:
                          PageManager(comment.url).progressNotifier,
                      builder: (_, value, __) {
                        return ProgressBar(
                          progress: value.current,
                          buffered: value.buffered,
                          total: value.total,
                          timeLabelLocation: TimeLabelLocation.sides,
                          onSeek: PageManager(comment.url).seek,
                          baseBarColor: const Color(0xFFDDE7E9),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => PageManager(comment.url).seek(
                            const Duration(
                                minutes: 0, seconds: 0, milliseconds: 0)),
                        child: const Icon(
                          Icons.repeat,
                          size: 12,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ValueListenableBuilder<ButtonState>(
                        valueListenable:
                            PageManager(comment.url).buttonNotifier,
                        builder: (_, value, __) {
                          switch (value) {
                            case ButtonState.loading:
                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 32.0,
                                height: 32.0,
                                child: const CircularProgressIndicator(),
                              );
                            case ButtonState.paused:
                              return ElevatedButton(
                                onPressed: () =>
                                    PageManager(comment.url).play(),
                                child: const Icon(
                                  Icons.play_arrow,
                                  size: 24,
                                ),
                              );
                            case ButtonState.playing:
                              return ElevatedButton(
                                onPressed: () =>
                                    PageManager(comment.url).pause(),
                                child: const Icon(
                                  Icons.pause,
                                  size: 24,
                                ),
                              );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ), //
            ),
          ],
        ),
      ),
    );
  }
}
