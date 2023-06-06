import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:our_voice/screens/recording/pageManager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RecordForm extends StatefulWidget {
  final BuildContext ctx;
  final String artId;
  final String uid;
  const RecordForm(
      {Key? key, required this.ctx, required this.artId, required this.uid})
      : super(key: key);

  @override
  RecordFormState createState() {
    return RecordFormState();
  }
}

class RecordFormState extends State<RecordForm> {
  bool _uploading = false;
  String _displayTexte = '%';
  String? timestamp;
  double progressValue = 0;
  final storage = FirebaseStorage.instance;
  String? path;
  final recorder = FlutterSoundRecorder();
  PageManager? _pageManager = PageManager.empty();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future<void> record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future<void> stopRecording() async {
    if (!isRecorderReady) return;
    path = await recorder.stopRecorder();
    _pageManager = PageManager(path!, fileInit: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return buildBottomModalSheet(super.widget.ctx);
  }

  Widget buildBottomModalSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      'Record what you feel about this',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                recordingSection(context),
                playerSection(context),
                _uploading
                    ? progressValue == 0
                        ? Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 32.0,
                            height: 32.0,
                            child: const CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: FAProgressBar(
                              currentValue: progressValue,
                              displayText: _displayTexte,
                            ),
                          )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          if (!_uploading) {
                            await uploadToFirebase(
                                context, super.widget.artId, super.widget.uid);
                            Navigator.pop(context);
                          }
                        },
                        icon: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.send_rounded,
                            size: 30,
                          ),
                        ),
                        label: Text(
                          'SEND',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5);
                              }
                              return Colors.green;
                            },
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).orientation == Orientation.landscape
                ? 85.h
                : 85.w,
            top: -5,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 30,
              color: Colors.black45,
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Widget recordingSection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<RecordingDisposition>(
            stream: recorder.onProgress,
            builder: (context, snapshot) {
              final duration =
                  snapshot.hasData ? snapshot.data!.duration : Duration.zero;
              String twoDigits(int n) => n.toString().padLeft(2, "0");
              final firstNumber = twoDigits(duration.inMinutes.remainder(60));
              final secondNumber = twoDigits(duration.inSeconds.remainder(60));

              if (duration.inMinutes.remainder(60) == 1) {
                stopRecording();
              }
              return Text(
                '$firstNumber:$secondNumber / 01:00',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              );
            },
          ),
          ElevatedButton(
            child: Icon(
              recorder.isRecording ? Icons.stop : Icons.mic,
              size: 30,
            ),
            onPressed: () async {
              if (recorder.isRecording) {
                await stopRecording();
              } else {
                await record();
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget playerSection(BuildContext context) {
    double sW = 0;
    bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (landscape) {
      sW = 1.h;
    } else {
      sW = 1.w;
    }
    if (_pageManager!.fileInit) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 65 * sW,
            child: ValueListenableBuilder<ProgressBarState>(
              valueListenable: _pageManager!.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: _pageManager!.seek,
                );
              },
            ),
          ),
          ValueListenableBuilder<ButtonState>(
            valueListenable: _pageManager!.buttonNotifier,
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
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 32.0,
                    onPressed: () {
                      _pageManager!.play();
                    },
                  );
                case ButtonState.playing:
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 32.0,
                    onPressed: () {
                      _pageManager!.pause();
                    },
                  );
              }
            },
          ),
        ],
      );
    } else {
      return Column();
    }
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    var myUri = Uri.parse(filePath);
    var audioFile = File.fromUri(myUri);
    Uint8List bytes;
    var b = await audioFile.readAsBytes();
    bytes = Uint8List.fromList(b);
    return bytes;
  }

  Future<void> startPlayer() async {
    String? audioFilePath;
    // Do we want to play from buffer or from file ?
    if (kIsWeb || await fileExists(path!)) {
      audioFilePath = path;
    }
    if (audioFilePath != null) {
      setState(() {
        _pageManager = PageManager(path!, fileInit: true);
      });
    }
    setState(() {});
  }

  Future<void> uploadToFirebase(
      BuildContext context, String artId, String uid) async {
    timestamp =
        DateTime.now().difference(DateTime(2022, 09, 11)).inSeconds.toString();
    _displayTexte = '% uploading sound..';
    _uploading = true;
    if (FirebaseAuth.instance.currentUser != null &&
        !FirebaseAuth.instance.currentUser!.isAnonymous &&
        path != null &&
        await fileExists(path!)) {
      String ref = randomAlpha(20);
      final uploadTask =
          storage.ref('recs/$ref.mp3').putData(await _readFileByte(path!));
      final TaskSnapshot taskSnapshot = await uploadTask;
      final url = await taskSnapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('Comments').doc().set(
        {
          "url": url,
          "ArtID": artId,
          "Commentor": uid,
          'praises': [],
          'critics': [],
        },
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            changeValue(100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes));
            break;
          case TaskState.paused:
            //print("Upload is paused.");
            break;
          case TaskState.canceled:
            // print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            await updateDatabase(context);
            break;
        }
      });
    } else if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.isAnonymous) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Please log in first',
        ),
        displayDuration: const Duration(microseconds: 750),
      );
      _uploading = false;
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Record something first',
        ),
        displayDuration: const Duration(microseconds: 750),
      );
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> pauseRecorder() async {
    if (!isRecorderReady) return;
    if (recorder.isRecording) {
      await recorder.pauseRecorder();
    }
  }

  Future<void> resumeRecorder() async {
    if (!isRecorderReady) return;
    if (recorder.isPaused) {
      await recorder.resumeRecorder();
    }
  }

  Future<void> updateDatabase(BuildContext context) async {
    _displayTexte = '% updating dataBase..';
    progressValue = 0;
    _uploading = true;
    changeValue(0);

    // FirebaseFirestore.instance.collection('Comments').doc().set({"url": rec});

    // final UserRecord ua = UserRecord(
    //   MyApp.me!.un,
    //   DateFormat('dd/MM/y').add_Hms().format(TZDateTime.now(MyApp.algiers!)),
    //   downloadLink,
    //   MyApp.me!.pi!,
    //   false,
    //   0,
    //   0,
    //   pa: super.widget.parent != null && super.widget.parent!.isNotEmpty
    //       ? super.widget.parent
    //       : null,
    // );

    // if(super.widget.parent!=null && super.widget.parent!.isNotEmpty){

    //   Map<String, Object?> updates = {};

    //   updates['userAudioChild/${ArtDetails.keyShowing}/${MyApp.me!.un+timestamp!}'] = ua.toJson();
    //   updates['numAudioChild/${ArtDetails.keyShowing}/${super.widget.parent!}'] = ServerValue.increment(1);
    //   await FirebaseDatabase.instance.ref().update(updates);

    // }
    if (super.widget.artId.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();

      await batch.commit();
    }
    // else{
    //   await db
    //       .ref(
    //       'userAudio/${ArtDetails.keyShowing}/${MyApp.me!.un+timestamp!}/')
    //       .set(ua.toJson());
    // }
    else {}

    changeValue(100);

    _uploading = false;
  }

  void changeValue(double value) {
    setState(() {
      progressValue = value;
    });

    if (value == 100) {
      Future.delayed(const Duration(milliseconds: 300))
          .then((value) => Navigator.pop(context));
    }
  }
}
