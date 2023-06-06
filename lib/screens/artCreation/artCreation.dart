import 'dart:io';
import 'dart:math' as math;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_voice/screens/auth/signup_screen.dart';
import 'package:our_voice/services/artCreationForm.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';

class ArtCreationScreen extends StatefulWidget {
  const ArtCreationScreen({Key? key}) : super(key: key);
  static String id = "ArtCreation";

  @override
  State<StatefulWidget> createState() {
    return ArtCState();
  }
}

class ArtCState extends State<ArtCreationScreen>
    with SingleTickerProviderStateMixin {
  String? _retrieveDataCoverError;
  dynamic _pickImageCoverError;

  AutoScrollController controller = AutoScrollController();
  TabController? tabController;

  bool showMore = false;
  bool toSell = false;

  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  static String? artKey;
  int selectedDL = 0;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: selectedDL,
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        create: (context) => ArtCreationBloc(),
        child: Builder(
          builder: (context) {
            final formBloc = context.read<ArtCreationBloc>();
            formBloc.toSell.onValueChanges(onData: (previous, current) async* {
              setState(() {
                toSell = current.value;
              });
            });
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'ART CREATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.12,
                  ),
                ),
              ),
              body: SafeArea(
                child: FormBlocListener<ArtCreationBloc, String, String>(
                  key: _formKey,
                  formBloc: formBloc,
                  onSubmitting: (context, state) =>
                      LoadingDialog.show(context, state),
                  onSubmissionFailed: (context, state) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Error")));
                    LoadingDialog.hide(context);
                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    if (state.stepCompleted == state.lastStep) {
                      Navigator.pop(context);
                    }
                  },
                  onFailure: (context, state) {
                    if (state.hasFailureResponse) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.failureResponse!)));
                    }
                    LoadingDialog.hide(context);
                  },
                  child: artCreationWidgets(formBloc),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  formBloc.emitSubmitting();
                  formBloc.onSubmitting();
                  formBloc.submit();
                  formBloc.submit;
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            );
          },
        ),
      ),
    );
  }

  Text? _getRetrieveErrorCoverWidget() {
    if (_retrieveDataCoverError != null) {
      final Text result = Text(_retrieveDataCoverError!);
      _retrieveDataCoverError = null;
      return result;
    }
    return null;
  }

  Widget _previewImagesCover() {
    final Text? retrieveError = _getRetrieveErrorCoverWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (ArtCreationBloc.imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: kIsWeb
            ? Image.network(
                ArtCreationBloc.imageFileList![0].path,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(ArtCreationBloc.imageFileList![0].path),
                fit: BoxFit.cover,
              ),
      );
    } else if (_pickImageCoverError != null) {
      return Text(
        'Pick image error: $_pickImageCoverError',
        textAlign: TextAlign.center,
      );
    } else {
      return Image.asset(
        'images/cover.jpg',
        fit: BoxFit.cover,
      );
    }
  }

  void _displayPickImageDialog(OnPickImageCallback onPick, {int type = 0}) {
    if (type == 0) {
      onPick(400, 400, null);
    } else {
      onPick(1024, 1024, null);
    }
  }

  void _setImageFileCoverListFromFile(XFile? value) {
    ArtCreationBloc.imageFileList = value == null ? null : <XFile>[value];
  }

  Future<void> _onImageCoverButtonPressed(ImageSource source,
      {BuildContext? context, int type = 1}) async {
    _displayPickImageDialog(type: type,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _setImageFileCoverListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageCoverError = e;
        });
      }
    });
  }

  Widget artCreationWidgets(ArtCreationBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        controller: controller,
        children: [
          AutoScrollTag(
            key: const ValueKey(0),
            controller: controller,
            index: 0,
            child: SizedBox(
              height: 25.h,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned.fill(
                    child: Container(
                      height: 25.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _previewImagesCover(),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      width: 30.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_photo_alternate),
                            onPressed: () {
                              _onImageCoverButtonPressed(ImageSource.gallery,
                                  context: context, type: 1);
                            },
                            iconSize: 32,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_a_photo),
                            onPressed: () {
                              _onImageCoverButtonPressed(ImageSource.camera,
                                  context: context, type: 1);
                            },
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ), //pic
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(1),
            controller: controller,
            index: 1,
            child: TextFieldBlocBuilder(
              textFieldBloc: bloc.name,
              suffixButton: SuffixButton.asyncValidating,
              keyboardType: TextInputType.text,
              maxLength: 30,
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                      text: '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Title '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.red[900],
                          ),
                        ),
                      ]),
                ),
                isDense: true,
                filled: true,
                prefixIcon: const Icon(Icons.title),
              ),
            ),
          ), //title
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(2),
            controller: controller,
            index: 2,
            child: SizedBox(
              width: 100.w,
              child: CheckboxFieldBlocBuilder(
                booleanFieldBloc: bloc.toSell,
                controlAffinity: FieldBlocBuilderControlAffinity.trailing,
                body: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Is this for sale ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),

          AutoScrollTag(
            key: const ValueKey(3),
            controller: controller,
            index: 3,
            child: toSell
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFieldBlocBuilder(
                          textFieldBloc: bloc.price,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: RichText(
                              text: const TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(text: 'Price '),
                                  ]),
                            ),
                            isDense: true,
                            filled: true,
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: DropdownFieldBlocBuilder(
                          selectFieldBloc: bloc.currency,
                          decoration: const InputDecoration(
                            labelText: 'Currency',
                            prefixIcon: Icon(Icons.money),
                            filled: true,
                            isDense: true,
                          ),
                          itemBuilder: (context, String value) => FieldItem(
                            child: Text(value),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ), //price
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(4),
            controller: controller,
            index: 4,
            child: DropdownSearch<String>(
              popupProps: PopupProps.dialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.palette),
                    Text(
                      'TECHNIQUE USED',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                showSelectedItems: true,
                showSearchBox: true,
              ),
              items: techniques,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Technique",
                  hintText: "Technique used for art",
                  prefixIcon: Icon(Icons.palette),
                  isDense: true,
                  filled: true,
                ),
              ),
              onChanged: (v) {
                bloc.technique = getIndex(techniques, v!);
              },
              selectedItem: "Acrylic",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(5),
            controller: controller,
            index: 5,
            child: DropdownSearch<String>(
              popupProps: PopupProps.dialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.style),
                    Text(
                      'ART STYLE',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                showSelectedItems: true,
                showSearchBox: true,
              ),
              items: styles,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Style",
                  hintText: "Art style",
                  prefixIcon: Icon(Icons.style),
                  isDense: true,
                  filled: true,
                ),
              ),
              onChanged: (v) {
                bloc.style = getIndex(styles, v!);
              },
              selectedItem: "Mannerism",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(6),
            controller: controller,
            index: 6,
            child: DropdownSearch<String>(
              popupProps: PopupProps.dialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.history_edu),
                    Text(
                      'ART SUBJECT',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                showSelectedItems: true,
                showSearchBox: true,
              ),
              items: subjects,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Subject",
                  hintText: "Art subject",
                  prefixIcon: Icon(Icons.history_edu),
                  isDense: true,
                  filled: true,
                ),
              ),
              onChanged: (v) {
                bloc.subject = getIndex(subjects, v!);
              },
              selectedItem: "History Painting",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(7),
            controller: controller,
            index: 7,
            child: DropdownSearch<String>(
              popupProps: PopupProps.dialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.video_stable),
                    Text(
                      'ART SUPPORT',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                showSelectedItems: true,
                showSearchBox: true,
              ),
              items: supports,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Support",
                  hintText: "Art Support/Material",
                  prefixIcon: Icon(Icons.video_stable),
                  isDense: true,
                  filled: true,
                ),
              ),
              onChanged: (v) {
                bloc.support = getIndex(supports, v!);
              },
              selectedItem: "Canvas",
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          AutoScrollTag(
            key: const ValueKey(8),
            controller: controller,
            index: 8,
            child: RadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: bloc.typeOfCopy,
              canTapItemTile: true,
              decoration: const InputDecoration(
                labelText: 'Type of copy',
                prefixIcon: Icon(Icons.copy),
                filled: true,
                isDense: true,
              ),
              itemBuilder: (context, item) => FieldItem(
                child: Text(item),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(9),
            controller: controller,
            index: 9,
            child: DateTimeFieldBlocBuilder(
              dateTimeFieldBloc: bloc.dateCreation,
              format: DateFormat.yMd(),
              initialDate: DateTime(1980, 1, 1),
              firstDate: DateTime(0, 1, 1),
              lastDate: DateTime.now(),
              showClearIcon: false,
              decoration: const InputDecoration(
                labelText: 'Date of creation',
                prefixIcon: Icon(Icons.calendar_month),
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
                isDense: true,
                filled: true,
              ),
            ),
          ), //date of creation
          const SizedBox(
            height: 10,
          ),
          AutoScrollTag(
            key: const ValueKey(10),
            controller: controller,
            index: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showMore = !showMore;
                });
                if (showMore) {
                  waitAndScroll(10);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.more,
                      color: showMore
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    Text(
                      'More infos',
                      style: TextStyle(
                        color: showMore
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    Transform.rotate(
                      angle: showMore ? 180 * math.pi / 180 : 0,
                      child: Icon(
                        Icons.arrow_circle_up,
                        color: showMore
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          AutoScrollTag(
            key: const ValueKey(11),
            controller: controller,
            index: 11,
            child: showMore
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        controller: tabController,
                        onTap: (index) {
                          setState(() {
                            selectedDL = index;
                            tabController!.animateTo(index);
                          });
                        },
                        isScrollable: true,
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10,
                        ),
                        // labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'English'),
                          Tab(text: 'Arabic'),
                          Tab(text: 'French'),
                          Tab(text: 'Spanish'),
                          Tab(text: 'German'),
                        ],
                      ),
                      const Divider(height: 0),
                      IndexedStack(
                        index: selectedDL,
                        children: [
                          Visibility(
                            maintainState: true,
                            visible: selectedDL == 0,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.descriptionEN,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: const TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        TextSpan(text: 'Describe your piece'),
                                      ]),
                                ),
                                isDense: true,
                                filled: true,
                                prefixIcon: const Icon(Icons.description),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          Visibility(
                            maintainState: true,
                            visible: selectedDL == 1,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.descriptionAR,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: const TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        TextSpan(text: 'صف قطعتك الفنية'),
                                      ]),
                                ),
                                isDense: true,
                                filled: true,
                                prefixIcon: const Icon(Icons.description),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          Visibility(
                            maintainState: true,
                            visible: selectedDL == 2,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.descriptionFR,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: const TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        TextSpan(text: 'Décrivez votre oeuvre'),
                                      ]),
                                ),
                                isDense: true,
                                filled: true,
                                prefixIcon: const Icon(Icons.description),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          Visibility(
                            maintainState: true,
                            visible: selectedDL == 3,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.descriptionES,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: const TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'Describe tu obra de arte'),
                                      ]),
                                ),
                                isDense: true,
                                filled: true,
                                prefixIcon: const Icon(Icons.description),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          Visibility(
                            maintainState: true,
                            visible: selectedDL == 4,
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.descriptionDE,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: const TextSpan(
                                      text: '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'Beschreibe dein Kunstwerk'),
                                      ]),
                                ),
                                isDense: true,
                                filled: true,
                                prefixIcon: const Icon(Icons.description),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Size (cm)',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.width,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text('Width'),
                                isDense: true,
                                filled: true,
                              ),
                            ),
                          ),
                          const Text('x'),
                          Expanded(
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.height,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text('Height'),
                                isDense: true,
                                filled: true,
                              ),
                            ),
                          ),
                          const Text('x'),
                          Expanded(
                            child: TextFieldBlocBuilder(
                              textFieldBloc: bloc.lenght,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text('Lenght'),
                                isDense: true,
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                        popupProps: PopupProps.dialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.copyright),
                              Text(
                                'CERTIFICATE',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          showSelectedItems: true,
                        ),
                        items: certificates,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Certificate",
                            hintText: "Art certificate",
                            filled: true,
                            isDense: true,
                            prefixIcon: Icon(Icons.copyright),
                          ),
                        ),
                        onChanged: (v) {
                          bloc.certificate = getIndex(certificates, v!);
                        },
                        selectedItem: "None",
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       'Main color ',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500, fontSize: 18),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               titlePadding: const EdgeInsets.all(0),
                      //               contentPadding: const EdgeInsets.all(0),
                      //               content: SingleChildScrollView(
                      //                 child: MaterialPicker(
                      //                   pickerColor: colorPicked,
                      //                   onColorChanged: (color) {
                      //                     colorPicked = color;
                      //                     bloc.color = color.value;
                      //                   },
                      //                   enableLabel: true,
                      //                   portraitOnly: true,
                      //                 ),
                      //               ),
                      //               actions: [
                      //                 ElevatedButton(
                      //                   child: const Text('Confirm'),
                      //                   onPressed: () {
                      //                     changeColor(colorPicked);
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //       style: ButtonStyle(
                      //         backgroundColor:
                      //             MaterialStateProperty.all<Color>(colorPicked),
                      //       ),
                      //       child: Container(
                      //         color: colorPicked,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: bloc.dateStarting,
                        format: DateFormat.yMd(),
                        initialDate: DateTime(1980, 1, 1),
                        firstDate: DateTime(0, 1, 1),
                        lastDate: DateTime.now(),
                        showClearIcon: false,
                        decoration: const InputDecoration(
                          labelText: 'Started in',
                          prefixIcon: Icon(Icons.calendar_month),
                          labelStyle: TextStyle(
                            color: Colors.black38,
                          ),
                          filled: true,
                          isDense: true,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: bloc.link,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          label: RichText(
                            text: const TextSpan(
                                text: '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(text: 'Link'),
                                ]),
                          ),
                          isDense: true,
                          filled: true,
                          prefixIcon: const Icon(Icons.link),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Art rewards',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      BlocBuilder<ListFieldBloc<RewardFieldBloc, dynamic>,
                          ListFieldBlocState<RewardFieldBloc, dynamic>>(
                        bloc: bloc.rewards,
                        builder: (context, state) {
                          if (state.fieldBlocs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: state.fieldBlocs.length,
                              itemBuilder: (context, i) {
                                return MemberCard(
                                  memberIndex: i,
                                  memberField: state.fieldBlocs[i],
                                  onRemoveMember: () => bloc.removeReward(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: bloc.addReward,
                        child: const Text(
                          'ADD REWARD',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  void waitAndScroll(int index) {
    Future.delayed(const Duration(milliseconds: 300)).whenComplete(() =>
        controller.scrollToIndex(index,
            preferPosition: AutoScrollPosition.begin));
  }

  int getIndex(List<String> l, String value) {
    for (int i = 0; i < l.length; i++) {
      if (l[i] == value) {
        return i;
      }
    }

    return -1;
  }

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
}

class MemberCard extends StatelessWidget {
  final int memberIndex;
  final RewardFieldBloc memberField;

  final VoidCallback onRemoveMember;

  const MemberCard({
    Key? key,
    required this.memberIndex,
    required this.memberField,
    required this.onRemoveMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Reward #${memberIndex + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.reward,
              decoration: const InputDecoration(
                labelText: 'label it',
                filled: true,
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
