import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:our_voice/services/database.dart';
import 'package:validators2/validators2.dart';

class ArtCreationBloc extends FormBloc<String, String> {
  static List<XFile>? imageFileList;

  int w = 0;
  int h = 0;

  int technique = 0;
  int style = 0;
  int subject = 0;
  int support = 0;
  int certificate = 0;
  int? color = 0xFFFFFFFF;

  static final List<String> techniques = [
    "Acrylic",
    "Action Painting",
    "Aerial Perspective",
    "Anamorphosis",
    "Camaieu",
    "Casein",
    "Charcoal Drawing",
    "Chiaroscuro",
    "Collage",
    "Color Pencil Sketch",
    "Digital",
    "Encaustic",
    "Foreshortening",
    "Fresco",
    "Glass",
    "Gouache",
    "Graffiti",
    "Grisaille",
    "Handmade",
    "Impasto",
    "Ink",
    "Miniature",
    "Mural",
    "Oil",
    "Panel",
    "Panorama",
    "Pastel",
    "Pencil Sketch",
    "Perspective",
    "Plein-Air",
    "Sand",
    "Scroll",
    "Sfumato",
    "Sotto In Su",
    "Spray",
    "Stone",
    "Tachism",
    "Tempera",
    "Tenebrism",
    "Tromp L’œil",
    "Veduta",
    "Watercolour",
  ];
  static final List<String> styles = [
    "Renaissance/ High Renaissance",
    "Mannerism",
    "Baroque",
    "Neoclassicism",
    "Romanticism",
    "Realism",
    "Impressionism",
    "Pointillism/ Divisionism",
    "Symbolism",
    "Art Nouveau",
    "Fauvism",
    "Expressionism",
    "Cubism",
    "Constructivism",
    "Futurism",
    "Dadaism",
    "Surrealism",
    "Abstract Expressionism",
    "Pop Art",
    "Photorealism",
    "Minimalism",
  ];

  static final List<String> subjects = [
    "History Painting",
    "Portrait Art",
    "Genre Painting",
    "Landscape Painting",
    "Still Life Painting",
    "Abstract Painting",
    "Religious Painting",
    "Allegory Painting",
  ];

  static final List<String> supports = [
    "Canvas",
    "Card stock",
    "Concrete",
    "Digital",
    "Fabric",
    "Glass",
    "Human body",
    "Metal",
    "Paper",
    "Plaster",
    "Scratchboard",
    "Stone",
    "Vellum",
    "Wood",
  ];

  static final List<String> certificates = [
    "None",
    "Artist",
    "Art gallery",
  ];

  static String? alphaNumOnly(String value) {
    if (value.isNotEmpty && !RegExp(r'^[a-zA-Z\d_ ]+$').hasMatch(value)) {
      return 'Only alphanumeric characters allowed';
    }
    return null;
  }

  static String? validateUrl(String value) {
    if (value.trim().isEmpty) {
      return null;
    } else if (isURL(value)) {
      return null;
    } else {
      return "Enter a valid URL (exemple.com)";
    }
  }

  final name = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      alphaNumOnly,
    ],
  );

  final dateCreation = InputFieldBloc<DateTime, Object>(
    initialValue: DateTime(1980, 01, 01),
    name: 'dateOfCreation',
    toJson: (value) => value.toUtc().toIso8601String(),
  );

  final toSell = BooleanFieldBloc();
  final currency = SelectFieldBloc(
    items: ['Dinar (DZD)', 'Euro (EUR)', 'Dollar (USD)'],
    initialValue: 'Euro (EUR)',
  );

  final typeOfCopy = SelectFieldBloc(
    items: ['Original', 'Replica'],
    initialValue: 'Original',
  );

  final price = TextFieldBloc();

  final descriptionEN = TextFieldBloc();
  final descriptionAR = TextFieldBloc();
  final descriptionFR = TextFieldBloc();
  final descriptionES = TextFieldBloc();
  final descriptionDE = TextFieldBloc();
  final width = TextFieldBloc();
  final height = TextFieldBloc();
  final lenght = TextFieldBloc();
  final dateStarting = InputFieldBloc<DateTime, Object>(
    initialValue: DateTime(1980, 01, 01),
    name: 'dateOfBegining',
    toJson: (value) => value.toUtc().toIso8601String(),
  );
  final rewards = ListFieldBloc<RewardFieldBloc, dynamic>(name: 'rewards');
  final link = TextFieldBloc(
    validators: [
      validateUrl,
    ],
  );

  ArtCreationBloc() {
    toSell.onValueChanges(onData: (previous, current) async* {
      if (current.value) {
        addFieldBlocs(fieldBlocs: [price, currency]);
      } else {
        removeFieldBlocs(fieldBlocs: [price, currency]);
      }
    });
    addFieldBlocs(fieldBlocs: [
      name,
      dateCreation,
      typeOfCopy,
      toSell,
      if (toSell.value) price,
      if (toSell.value) currency,
      descriptionEN,
      descriptionFR,
      descriptionAR,
      descriptionES,
      descriptionDE,
      width,
      height,
      lenght,
      dateStarting,
      rewards,
      link,
    ]);
  }

  void addReward() {
    rewards.addFieldBloc(
        RewardFieldBloc(name: 'reward', reward: TextFieldBloc(name: 'reward')));
  }

  void removeReward(int index) {
    rewards.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {
    emitSubmitting();
    print("Submitting");
    if (imageFileList == null ||
        imageFileList![0].path.isEmpty ||
        !await File(imageFileList![0].path).exists()) {
      debugPrint('here');
      emitFailure(failureResponse: 'A picture is required');
    } else if (descriptionDE.value.isEmpty &&
        descriptionES.value.isEmpty &&
        descriptionFR.value.isEmpty &&
        descriptionAR.value.isEmpty &&
        descriptionEN.value.isEmpty) {
      emitFailure(
          failureResponse:
              'At least a description in any language is required');
    } else {
      String pic = await uploadPic().onError((error, stackTrace) {
        return '';
      });

      if (pic.isEmpty) {
        emitFailure(failureResponse: 'Error uploading pic');
      } else {
        final db = Database();
        try {
          await db.saveart(
            name: name.value,
            type: typeOfCopy.value.toString(),
            image: pic,
            descriptionEn: descriptionEN.value,
            height: height.valueToDouble!.toDouble(),
            width: width.valueToInt!.toDouble(),
            length: lenght.valueToDouble!.toDouble(),
            dateCreated: dateCreation.value,
            technique: techniques[technique],
            style: styles[style],
            subject: subjects[subject],
            support: supports[support],
            copy: typeOfCopy.value,
            price: price.valueToDouble!.toDouble(),
            currency: currency.value.toString(),
            toSell: toSell.value,
            certificate: certificates[certificate],
            rewards: rewards.value,
            links: '',
            descriptionAr: descriptionAR.value,
            descriptionFr: descriptionFR.value,
            descriptionSp: descriptionES.value,
            descriptionGr: descriptionDE.value,
          );
          // TODO: in the current user's collection, add 1 to filled and -1 to canvas.
        } catch (error, stackTrace) {
          emitFailure(failureResponse: error.toString());
        }

        emitSuccess();
      }
    }
  }

  Future<String> uploadPic() async {
    if (imageFileList != null) {
      if (imageFileList![0].path.isEmpty ||
          !await File(imageFileList![0].path).exists()) {
        return 'd';
      }
      final f = File(imageFileList![0].path);
      List<int> wh = await getHeightWidth(f);
      w = wh[0];
      h = wh[1];
      DateTime now = DateTime.now();
      var datestamp = DateFormat("yyyyMMdd'T'HHmmss");
      String currentdate = datestamp.format(now);
      final uploadTask = await FirebaseStorage.instance
          .ref('images/$currentdate.jpg')
          .putData(await f.readAsBytes());

      switch (uploadTask.state) {
        case TaskState.canceled:
          return 'd';
        case TaskState.error:
          return 'd';
        case TaskState.success:
          return await FirebaseStorage.instance
              .ref('images/$currentdate.jpg')
              .getDownloadURL()
              .onError((error, stackTrace) {
            return 'd';
          },
          );
        case TaskState.paused:
          return 'd';
        case TaskState.running:
          return 'd';
      }
    } else {
      return 'd';
    }
  }

  Future<List<int>> getHeightWidth(File f) async {
    final size = ImageSizeGetter.getSize(FileInput(f));

    if (size.needRotate) {
      return [size.height, size.width];
    } else {
      return [size.width, size.height];
    }
  }

  String createRewardString() {
    String r = '';

    for (int i = 0; i < rewards.value.length; i++) {
      r += '${rewards.value[i].reward.value};';
    }

    return r;
  }

  @override
  Future<void> close() {
    name.close();
    dateCreation.close();
    typeOfCopy.close();
    price.close();
    currency.close();
    descriptionEN.close();
    descriptionAR.close();
    descriptionFR.close();
    descriptionES.close();
    descriptionDE.close();
    width.close();
    height.close();
    lenght.close();
    dateStarting.close();
    rewards.close();
    link.close();
    if (imageFileList != null) {
      imageFileList!.clear();
      imageFileList = null;
    }

    return super.close();
  }
}

class RewardFieldBloc extends GroupFieldBloc {
  final TextFieldBloc reward;
  RewardFieldBloc({
    required this.reward,
    String? name,
  }) : super(name: name, fieldBlocs: [
          reward,
        ]);
}
