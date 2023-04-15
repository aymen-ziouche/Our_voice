import 'dart:async';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_voice/services/auth.dart';

class WizardFormBloc extends FormBloc<String, String> {
  final _auth = Auth();
  //step 0
  static List<XFile>? imageFileList;
  static List<XFile>? imageFileCoverList;

  String? phoneInitial = '+213';
  String? country = 'Algeria';

  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      alphaNumOnly,
      _min4Char,
    ],
  );
  final email = TextFieldBloc();
  final password = TextFieldBloc(validators: [
    FieldBlocValidators.required,
    FieldBlocValidators.passwordMin6Chars,
  ]);
  final userType = SelectFieldBloc(
    initialValue: '',
    validators: [FieldBlocValidators.required],
    items: [
      'Art enthusiast',
      'Amateur artist',
      'Professional artist',
      'Professional critical artist',
    ],
  );

  static String? alphaNumOnly(String value) {
    if (value.isNotEmpty && !RegExp(r'^\w+$').hasMatch(value)) {
      return 'Only alphanumeric characters allowed';
    }
    return null;
  }

  static String? _min4Char(String username) {
    if (username.length < 4) {
      return 'The username must have at least 4 characters';
    }
    return null;
  }

  //step 1
  final fullname = TextFieldBloc();
  final gender = SelectFieldBloc(
    name: 'Gender',
    items: ['Male', 'Female', 'Do not specify'],
  );
  final birthDate = InputFieldBloc<DateTime, Object>(
    initialValue: DateTime(1980, 01, 01),
    name: 'birthDate',
    toJson: (value) => value.toUtc().toIso8601String(),
  );
  final bio = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);
  final phone = TextFieldBloc(
    validators: [
      validateMobile,
    ],
  );
  final showPhone = BooleanFieldBloc();

  static String? validateMobile(String value) {
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

  //step 2
  final city = TextFieldBloc();
  final postalCode = TextFieldBloc();

  WizardFormBloc() {
    addFieldBlocs(step: 0, fieldBlocs: [
      username,
      userType,
      email,
      password,
    ]);
    userType.onValueChanges(onData: (previous, current) async* {
      if (current.value == 'Art enthusiast') {
        removeFieldBlocs(
          step: 1,
          fieldBlocs: [
            username,
            fullname,
            gender,
            birthDate,
            bio,
            phone,
            showPhone,
          ],
        );
        removeFieldBlocs(step: 2, fieldBlocs: [
          city,
          postalCode,
        ]);
      } else {
        addFieldBlocs(step: 1, fieldBlocs: [
          fullname,
          gender,
          birthDate,
          bio,
          phone,
          if (validateMobile(phone.value) == null &&
              phone.value.trim().isNotEmpty)
            showPhone,
        ]);

        addFieldBlocs(step: 2, fieldBlocs: [
          city,
          postalCode,
        ]);
      }
    });
    phone.onValueChanges(onData: (previous, current) async* {
      if (validateMobile(current.value) == null &&
          current.value.trim().isNotEmpty) {
        addFieldBloc(step: 1, fieldBloc: showPhone);
      } else {
        removeFieldBloc(step: 1, fieldBloc: showPhone);
      }
    });
  }
  Future<String> uploadProfile() async {
    if (imageFileList != null) {
      if (imageFileList![0].path.isEmpty ||
          !await File(imageFileList![0].path).exists()) {
        return 'null';
      }
      final f = File(imageFileList![0].path);
      final uploadTask = await FirebaseStorage.instance
          .ref('users/${email.value}/logo.jpg')
          .putData(await f.readAsBytes());

      switch (uploadTask.state) {
        case TaskState.canceled:
          return 'null';
        case TaskState.error:
          return 'null';
        case TaskState.success:
          return await FirebaseStorage.instance
              .ref('users/${email.value}/logo.jpg')
              .getDownloadURL()
              .onError((error, stackTrace) {
            return 'null';
          });
        case TaskState.paused:
          return 'null';
        case TaskState.running:
          return 'null';
      }
    } else {
      return 'null';
    }
  }

  Future<String> uploadCover() async {
    if (imageFileCoverList != null) {
      if (imageFileCoverList![0].path.isEmpty ||
          !await File(imageFileCoverList![0].path).exists()) {
        return 'null';
      }
      final f = File(imageFileCoverList![0].path);
      final uploadTask = await FirebaseStorage.instance
          .ref('users/${email.value}/cover.jpg')
          .putData(await f.readAsBytes());

      switch (uploadTask.state) {
        case TaskState.canceled:
          return 'null';
        case TaskState.error:
          return 'null';
        case TaskState.success:
          return await FirebaseStorage.instance
              .ref('users/${email.value}/cover.jpg')
              .getDownloadURL()
              .onError((error, stackTrace) {
            return 'null';
          });
        case TaskState.paused:
          return 'null';
        case TaskState.running:
          return 'null';
      }
    } else {
      return 'null';
    }
  }

  @override
  FutureOr<void> onSubmitting() async {
    String cover = await uploadCover();
    emitSubmitting(progress: 0.4);
    String profile = await uploadProfile();
    emitSubmitting(progress: 0.6);
    if (state.currentStep == state.lastStep) {
      _auth.signUp(
        email.value,
        password.value,
        username.value,
        userType.value.toString(),
        fullname.value,
        gender.value.toString(),
        birthDate.value.toString(),
        bio.value,
        phone.value.trim().isEmpty
            ? ""
            : phoneInitial! + phone.value.toString(),
        showPhone.value,
        city.value,
        postalCode.value,
        userType.value.toString() == 'Art enthusiast' ? false : true,
        userType.value.toString() == 'Art enthusiast' ? 0 : 2,
        profile,
        cover,
      );

      emitSubmitting(progress: 1.0);
      emitSuccess();
    } else {
      emitSuccess();
    }
  }
}
