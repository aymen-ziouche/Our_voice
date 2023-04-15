import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_voice/services/auth.dart';
import 'package:our_voice/services/database.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:sizer/sizer.dart';

class AddArtPage extends StatefulWidget {
  const AddArtPage({Key? key}) : super(key: key);
  static String id = "AddArtPage";

  @override
  State<AddArtPage> createState() => _AddArtPageState();
}

class _AddArtPageState extends State<AddArtPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _artName = TextEditingController();
  final _artBreed = TextEditingController();
  final _artAge = TextEditingController();
  final _artDescription = TextEditingController();
  late File _artImage = File('');
  final _db = Database();
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          _artImage = File(pickedFile.path);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "No image selected",
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 80.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(
                        FontAwesomeIcons.pen,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _artName,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter the art\'s name!' : null,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter the art\'s name!',
                    hintStyle: TextStyle(
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _artDescription,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                  validator: (val) => val!.isEmpty
                      ? 'Please enter the art\'s description!'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter the art\'s description!',
                    hintStyle: TextStyle(
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _artBreed,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter the art\'s breed!' : null,
                  decoration: const InputDecoration(
                    labelText: 'Breed',
                    hintText: 'Enter the art\'s breed!',
                    hintStyle: TextStyle(
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _artAge,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter the art\'s age!' : null,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter the art\'s age!',
                    hintStyle: TextStyle(
                      color: Colors.black54,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                MainButton(
                  text: "Add Art",
                  hasCircularBorder: true,
                  onTap: () async {
                    if (_globalKey.currentState!.validate()) {
                      _globalKey.currentState!.save();
                      try {
                        // TODO: Save the art to a collection named "art" and then save the art 
                        
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
