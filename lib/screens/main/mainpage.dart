import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:our_voice/providers/userprovider.dart';
import 'package:our_voice/screens/QRViewExample.dart';
import 'package:our_voice/screens/addArtPage.dart';
import 'package:our_voice/screens/homepage.dart';
import 'package:our_voice/screens/profilePage.dart';
import 'package:our_voice/services/auth.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static String id = "MainPage";

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.fetchUser();
  }

  void _getCurrentpage(value) async {
    switch (value) {
      case 0:
        setState(() {
          _bottomNavIndex = value;
          _child = const HomePage();
        });
        break;
      case 1:
        setState(() {
          _bottomNavIndex = value;
          _child = ProfilePage();
        });
        break;
    }
  }

  Widget _child = const HomePage();

  var iconList = <IconData>[
    FontAwesomeIcons.house,
    FontAwesomeIcons.solidUser,
  ];

  var _bottomNavIndex = 0;
  bool loading = true;

  static final loadingWidget = LoadingAnimationWidget.flickr(
    leftDotColor: const Color(0xFF437f79),
    rightDotColor: const Color(0xFF7aab92),
    size: 100,
  );
  static final loadingWidgetSmall = LoadingAnimationWidget.flickr(
    leftDotColor: const Color(0xFF437f79),
    rightDotColor: const Color(0xFF7aab92),
    size: 60,
  );

  static final loadingWidgetSmallest = LoadingAnimationWidget.flickr(
    leftDotColor: const Color(0xFF437f79),
    rightDotColor: const Color(0xFF7aab92),
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserProvider>(builder: (context, provider, child) {
        return Scaffold(
          body: _child,
          floatingActionButton: provider.user != null
              ? provider.user!.pending == false
                  ? FloatingActionButton(
                      backgroundColor: Colors.indigo,
                      onPressed: () {
                        Navigator.pushNamed(context, AddArtPage.id);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : SpeedDial(
                      icon: Icons.menu,
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      overlayColor: Colors.transparent,
                      elevation: 20,
                      overlayOpacity: 0.4,
                      direction: SpeedDialDirection.up,
                      spaceBetweenChildren: 5,
                      animatedIcon: AnimatedIcons.menu_close,
                      children: [
                        SpeedDialChild(
                          onTap: () {
                            Navigator.pushNamed(context, QRViewExample.id);

                            // Navigator.of(context).push(MaterialPageRoute(
                            //   // builder: (context) => const QRViewExample(),
                            // ));
                          },
                          elevation: 20,
                          backgroundColor: const Color(0xFF018786),
                          child: const Icon(Icons.qr_code),
                          label: 'Scan QR code',
                        ),
                        SpeedDialChild(
                          onTap: () {
                            Navigator.pushNamed(context, AddArtPage.id);
                            // Navigator.pushNamed(context, '/canvas');
                          },
                          elevation: 20,
                          backgroundColor: const Color(0xFF03DAC6),
                          child: const Icon(Icons.add_photo_alternate),
                          label: 'Add a new art piece',
                        ),
                      ],
                    )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: Colors.white,
            activeColor: Colors.indigo,
            inactiveColor: Colors.black38,
            height: 60,
            icons: iconList,
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            onTap: (value) {
              _getCurrentpage(value);
            },
          ),
        );
      }),
    );
  }
}
