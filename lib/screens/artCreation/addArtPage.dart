import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:our_voice/providers/userprovider.dart';
import 'package:our_voice/screens/artCreation/artCreation.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddArtPage extends StatefulWidget {
  const AddArtPage({Key? key}) : super(key: key);
  static String id = "AddArtPage";

  @override
  State<AddArtPage> createState() => _AddArtPageState();
}

class _AddArtPageState extends State<AddArtPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 0,
      ),
      body: Consumer<UserProvider>(builder: (context, provider, child) {
        int free = provider.user!.canvas - provider.user!.filled;
        return SafeArea(
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
                  Text("You have $free canvas free"),
                  provider.user != null
                      ? GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: free == 0 ? 0 : free,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: FlipCard(
                                  front: Container(
                                    width: 80.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Icon(
                                      FontAwesomeIcons.pen,
                                      color: Colors.white,
                                    ),
                                  ),
                                  back: Container(
                                    width: 80.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.pushNamed(
                                            context, ArtCreationScreen.id);
                                      },
                                      child: const Icon(
                                        FontAwesomeIcons.arrowsToEye,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ));
      }),
    );
  }
}
