import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:our_voice/modules/user.dart';
import 'package:our_voice/providers/artProvider.dart';
import 'package:our_voice/providers/commentsProvider.dart';
import 'package:our_voice/providers/userprovider.dart';
import 'package:our_voice/screens/QRViewExample.dart';
import 'package:our_voice/screens/artCreation/addArtPage.dart';
import 'package:our_voice/screens/homepage.dart';
import 'package:our_voice/screens/profile/profilePage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
    _fetchData();
  }

  void _fetchData() {
    final userProvider = context.read<UserProvider>();
    userProvider.fetchUser();
    final artProvider = context.read<ArtProvider>();
    artProvider.fetchArts();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   final userProvider = context.read<UserProvider>();
  //   userProvider.fetchUser();
  //   final artProvider = context.read<ArtProvider>();
  //   artProvider.fetchArts();
  // }

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
          _child = ProfilePage(
            myuser: context.read<UserProvider>().user as User,
          );
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
    leftDotColor: const Color(0xff9FFFE4),
    rightDotColor: const Color(0xFFFF99CC),
    size: 100,
  );
  static final loadingWidgetSmall = LoadingAnimationWidget.flickr(
    leftDotColor: const Color(0xff9FFFE4),
    rightDotColor: const Color(0xFFFF99CC),
    size: 60,
  );

  static final loadingWidgetSmallest = LoadingAnimationWidget.flickr(
    leftDotColor: const Color(0xff9FFFE4),
    rightDotColor: const Color(0xFFFF99CC),
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(10.h),
                child: SizedBox(
                  height: 8.h,
                  width: 100.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Image.asset(
                          'images/logo2.png',
                        ),
                      ),
                      provider.user != null
                          ? Flexible(
                              fit: FlexFit.loose,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Takes the user to the praise page
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          provider.user!.praise.length
                                              .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const Text(
                                          "Praise",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Takes the user to the critics page
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          provider.user!.critic.length
                                              .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const Text(
                                          "Critic",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Takes the user to the followed page
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.userGroup,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Followed",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Takes the user to the likes page
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.solidHeart,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "likes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Takes the user to the notifications page
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.solidBell,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Notifications",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(),
                    ],
                  ),
                )),
            body: _child,
            floatingActionButton: provider.user != null
                ? provider.user!.pending == false
                    ? FloatingActionButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, AddArtPage.id);
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                        child: const Icon(
                          Icons.qr_code_2,
                          color: Colors.white,
                        ),
                      )
                    : SpeedDial(
                        icon: Icons.menu,
                        backgroundColor: Theme.of(context).primaryColor,
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
                            backgroundColor: const Color(0xFF1bdcff),
                            child: const Icon(Icons.qr_code),
                            label: 'Scan QR code',
                          ),
                          SpeedDialChild(
                            onTap: () {
                              Navigator.pushNamed(context, AddArtPage.id);
                              // Navigator.pushNamed(context, '/canvas');
                            },
                            elevation: 20,
                            backgroundColor: const Color(0xFF1bdcff),
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
              activeColor: Theme.of(context).primaryColor,
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
        },
      ),
    );
  }
}
