import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:our_voice/services/signupForm.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static String id = "SignupScreen";

  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool user = false;
  String initialCountry = 'DZ';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        create: (context) => WizardFormBloc(),
        child: Builder(builder: (context) {
          final formBloc = context.read<WizardFormBloc>();
          formBloc.userType.onValueChanges(onData: (previous, current) async* {
            if (current.hasValue) {
              if (current.value == 'Art enthusiast') {
                setState(() {
                  user = false;
                });
              } else {
                setState(() {
                  user = true;
                });
              }
            } else {
              setState(() {
                user = false;
              });
            }
          });
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFF9F0EB),
                    style: BorderStyle.solid,
                  ),
                ),
                isDense: true,
                fillColor: Colors.white,
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'PROFILE CREATION',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
              body: SafeArea(
                child: FormBlocListener<WizardFormBloc, String, String>(
                  onSubmitting: (context, state) =>
                      LoadingDialog.show(context, state),
                  onSubmissionFailed: (context, state) =>
                      LoadingDialog.hide(context),
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    if (state.stepCompleted == state.lastStep) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const MainPage()));
                    }
                  },
                  key: _formKey,
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                  },
                  child: !user
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: _profilWids(formBloc),
                            ),
                            formBloc.userType.value == 'Art enthusiast'
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        formBloc.submit();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFF585A82)),
                                      ),
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      : StepperFormBlocBuilder<WizardFormBloc>(
                          formBloc: formBloc,
                          type: StepperType.horizontal,
                          physics: const ClampingScrollPhysics(),
                          stepsBuilder: (formbloc) {
                            if (user) {
                              return [
                                _profileInfos(formbloc!),
                                _personalInfos(formbloc),
                                _addressInfos(formbloc),
                              ];
                            } else {
                              return [
                                _profileInfos(formbloc!),
                              ];
                            }
                          },
                        ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _profilWids(WizardFormBloc bloc) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                height: 20.h,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned.fill(
                      left: 5,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[900]!),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: _previewImagesCover(),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 0,
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size?>(
                                      (Set<MaterialState> states) {
                                return const Size(24, 24);
                              }),
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder?>((Set<MaterialState> states) {
                                return const CircleBorder();
                              }),
                            ),
                            onPressed: () {
                              _onImageCoverButtonPressed(ImageSource.gallery,
                                  context: context, type: 0);
                            },
                            child: const Icon(
                              Icons.photo,
                              size: 20,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size?>(
                                      (Set<MaterialState> states) {
                                return const Size(24, 24);
                              }),
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder?>((Set<MaterialState> states) {
                                return const CircleBorder();
                              }),
                            ),
                            onPressed: () {
                              _onImageCoverButtonPressed(ImageSource.camera,
                                  context: context, type: 1);
                            },
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 6.h,
                child: CircleAvatar(
                  radius: 7.h,
                  //  backgroundColor: ,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.h),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned.fill(
                          child: _previewImages(),
                        ),
                        Positioned(
                          right: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.resolveWith<
                                            Size?>((Set<MaterialState> states) {
                                      return const Size(22, 22);
                                    }),
                                    shape: MaterialStateProperty.resolveWith<
                                            OutlinedBorder?>(
                                        (Set<MaterialState> states) {
                                      return const CircleBorder();
                                    }),
                                  ),
                                  onPressed: () {
                                    _onImageButtonPressed(ImageSource.gallery,
                                        context: context, type: 0);
                                  },
                                  child: const Icon(
                                    Icons.photo,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.resolveWith<
                                            Size?>((Set<MaterialState> states) {
                                      return const Size(22, 22);
                                    }),
                                    shape: MaterialStateProperty.resolveWith<
                                            OutlinedBorder?>(
                                        (Set<MaterialState> states) {
                                      return const CircleBorder();
                                    }),
                                  ),
                                  onPressed: () {
                                    _onImageButtonPressed(ImageSource.camera,
                                        context: context, type: 0);
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ), //avatar and cover
        TextFieldBlocBuilder(
          textFieldBloc: bloc.username,
          suffixButton: SuffixButton.asyncValidating,
          keyboardType: TextInputType.text,
          autofillHints: const [AutofillHints.username],
          maxLength: 15,
          decoration: InputDecoration(
            label: RichText(
              text: const TextSpan(
                  text: '',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: 'Username '),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ]),
            ),
            isDense: true,
            // filled: true,
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: bloc.email,
          suffixButton: SuffixButton.asyncValidating,
          keyboardType: TextInputType.text,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(
            label: RichText(
              text: const TextSpan(
                  text: '',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: 'email '),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ]),
            ),
            isDense: true,
            filled: true,
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: bloc.password,
          suffixButton: SuffixButton.asyncValidating,
          obscureText: true,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(
            label: RichText(
              text: const TextSpan(
                  text: '',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: 'password '),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ]),
            ),
            isDense: true,
            filled: true,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RadioButtonGroupFieldBlocBuilder<String>(
          selectFieldBloc: bloc.userType,
          itemBuilder: (context, value) => FieldItem(
            child: Text(value),
          ),
          canDeselect: true,
          canTapItemTile: true,
          decoration: InputDecoration(
            labelText: 'USER TYPE',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            labelStyle: const TextStyle(
              color: Colors.black38,
            ),
          ),
        ),
      ],
    );
  }

  FormBlocStep _profileInfos(WizardFormBloc bloc) {
    return FormBlocStep(
      title: const Text('Profile'),
      content: _profilWids(bloc),
    );
  }

  FormBlocStep _personalInfos(WizardFormBloc bloc) {
    return FormBlocStep(
      title: const Text('Personal'),
      content: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFieldBlocBuilder(
                  textFieldBloc: bloc.fullname,
                  autofillHints: const [AutofillHints.givenName],
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    isDense: true,
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: bloc.birthDate,
            format: DateFormat.yMd(),
            initialDate: DateTime(1980, 1, 1),
            firstDate: DateTime(1900, 1, 1),
            lastDate: DateTime.now(),
            showClearIcon: false,
            decoration: const InputDecoration(
              labelText: 'Birthday',
              prefixIcon: Icon(Icons.calendar_month),
              labelStyle: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
          RadioButtonGroupFieldBlocBuilder(
            selectFieldBloc: bloc.gender,
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.toString()),
            ),
            canDeselect: true,
            canTapItemTile: true,
            decoration: const InputDecoration(
              labelText: 'Gender',
              labelStyle: TextStyle(
                color: Colors.black38,
              ),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: bloc.bio,
            maxLines: 4,
            scrollPadding: const EdgeInsets.all(100),
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            autocorrect: true,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              label: RichText(
                text: const TextSpan(
                    text: '',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(text: 'Describe yourself... '),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ]),
              ),
              isDense: true,
              filled: true,
            ),
          ),
          Row(
            children: [
              CountryCodePicker(
                initialSelection: initialCountry,
                favorite: const ['+213', 'DZ'],
                showCountryOnly: false,
                hideMainText: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                onChanged: (code) {
                  bloc.phoneInitial = code.dialCode;
                },
              ),
              Expanded(
                child: TextFieldBlocBuilder(
                  textFieldBloc: bloc.phone,
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    isDense: true,
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
          CheckboxFieldBlocBuilder(
            booleanFieldBloc: bloc.showPhone,
            body: Container(
              alignment: Alignment.centerLeft,
              child: const Text('Show my phone in profile'),
            ),
          ),
        ],
      ),
    );
  }

  FormBlocStep _addressInfos(WizardFormBloc bloc) {
    return FormBlocStep(
      title: const Text('Address'),
      content: Column(
        children: [
          Row(
            children: [
              CountryCodePicker(
                initialSelection: initialCountry,
                favorite: const ['+213', 'DZ'],
                showCountryOnly: true,
                hideMainText: true,
                showOnlyCountryWhenClosed: true,
                alignLeft: false,
                showDropDownButton: true,
                onChanged: (country) {
                  bloc.country = country.name;
                },
              ),
              Expanded(
                child: TextFieldBlocBuilder(
                  textFieldBloc: bloc.city,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.addressCity],
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    isDense: true,
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFieldBlocBuilder(
                  textFieldBloc: bloc.postalCode,
                  maxLines: 1,
                  autofillHints: const [AutofillHints.postalCode],
                  scrollPadding: const EdgeInsets.all(40),
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Postal code',
                    isDense: true,
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _setImageFileListFromFile(XFile? value) {
    WizardFormBloc.imageFileList = value == null ? null : <XFile>[value];
  }

  void _setImageFileCoverListFromFile(XFile? value) {
    WizardFormBloc.imageFileCoverList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  dynamic _pickImageCoverError;
  String? _retrieveDataError;
  String? _retrieveDataCoverError;
  final ImagePicker _picker = ImagePicker();
  final ImagePicker _pickerCover = ImagePicker();

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, int type = 0}) async {
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
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Future<void> _onImageCoverButtonPressed(ImageSource source,
      {BuildContext? context, int type = 1}) async {
    _displayPickImageDialog(type: type,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _pickerCover.pickImage(
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

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (WizardFormBloc.imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: kIsWeb
            ? Image.network(
                WizardFormBloc.imageFileList![0].path,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(WizardFormBloc.imageFileList![0].path),
                fit: BoxFit.cover,
              ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Image.asset(
        'images/placeholder.jpg',
      );
    }
  }

  Widget _previewImagesCover() {
    final Text? retrieveError = _getRetrieveErrorCoverWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (WizardFormBloc.imageFileCoverList != null) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: kIsWeb
            ? Image.network(
                WizardFormBloc.imageFileCoverList![0].path,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(WizardFormBloc.imageFileCoverList![0].path),
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

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          WizardFormBloc.imageFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Text? _getRetrieveErrorCoverWidget() {
    if (_retrieveDataCoverError != null) {
      final Text result = Text(_retrieveDataCoverError!);
      _retrieveDataCoverError = null;
      return result;
    }
    return null;
  }

  void _displayPickImageDialog(OnPickImageCallback onPick, {int type = 0}) {
    if (type == 0) {
      onPick(400, 400, null);
    } else {
      onPick(1024, 1024, null);
    }
  }

  String? validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.trim().replaceAll(' ', '').isEmpty) {
      return null;
    } else if (value.trim().startsWith('0')) {
      return 'Please remove \'0\' at the start';
    } else if (value.trim().replaceAll(' ', '').length != 9) {
      return 'Number must be of 9 digit';
    } else {
      return null;
    }
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, FormBlocState state, {Key? key}) =>
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(
          key: key,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: MainPageState.loadingWidget,
      ),
    );
  }
}
