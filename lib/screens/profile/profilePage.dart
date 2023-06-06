import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:our_voice/modules/art.dart';
import 'package:our_voice/modules/comment.dart';
import 'package:our_voice/modules/user.dart';
import 'package:our_voice/providers/artProvider.dart';
import 'package:our_voice/providers/commentsProvider.dart';
import 'package:our_voice/screens/auth/signin_screen.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:our_voice/services/auth.dart';
import 'package:our_voice/services/database.dart';
import 'package:our_voice/widgets/canvasViewWidget.dart';
import 'package:our_voice/widgets/commentsViewWidget.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  final User myuser;
  const ProfilePage({super.key, required this.myuser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabbar = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: StreamBuilder<QuerySnapshot>(
          stream: Database().loadusr(widget.myuser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 38.h,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Positioned(
                            child: SizedBox(
                              height: 27.h,
                              width: 100.w,
                              child: Image.network(
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: MainPageState.loadingWidgetSmall,
                                    );
                                  }
                                },
                                widget.myuser.coverPicture,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            bottom: -25.h,
                            left: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 6.3.h,
                                        backgroundColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        child: CircleAvatar(
                                          radius: 6.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7.h),
                                            child: Stack(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              children: [
                                                Positioned.fill(
                                                  child: Image.network(
                                                    widget
                                                        .myuser.profilePicture,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Center(
                                                          child: MainPageState
                                                              .loadingWidgetSmall,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        widget.myuser.fullname,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Followers"),
                            Text(widget.myuser.followers.length.toString()),
                          ],
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("followings"),
                            Text(widget.myuser.followings.length.toString()),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          onTap: (index) {
                            setState(() {
                              _selectedTabbar = index;
                            });
                          },
                          tabs: const [
                            Tab(
                              text: 'Artworks',
                            ),
                            Tab(
                              text: 'Comments',
                            ),
                          ],
                        ),
                        Builder(
                          builder: (_) {
                            if (_selectedTabbar == 0) {
                              return StreamBuilder(
                                stream: Database().loadmyart(widget.myuser.uid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Consumer<ArtProvider>(
                                      builder: (context, value, child) {
                                        return MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: value.myart.length,
                                            itemBuilder: (context, index) =>
                                                CanvasViewWidget(
                                              art: value.myart[index],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return const Center(
                                    child: Text("Loading..."),
                                  );
                                },
                              );
                            } else {
                              return StreamBuilder(
                                stream: Database().loadcmnt(widget.myuser.uid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Consumer<CommentsProvider>(
                                      builder: (context, value, child) {
                                        print(value.mycomnt);
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: value.mycomnt.length,
                                          itemBuilder: (context, index) =>
                                              CommentsViewWidget(
                                            comment: value.mycomnt[index],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return const Center(
                                    child: Text("Loading..."),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    MainButton(
                      text: 'Log Out',
                      onTap: () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigninPage()),
                          (Route<dynamic> route) => false,
                        );
                        await Auth().logout();
                      },
                    ),
                  ],
                ),
              );
            }
            return Center(child: MainPageState.loadingWidget);
          },
        ),
      ),
    );
  }
}
