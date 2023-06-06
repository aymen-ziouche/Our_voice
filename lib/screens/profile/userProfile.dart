import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:our_voice/modules/art.dart';
import 'package:our_voice/modules/comment.dart';
import 'package:our_voice/modules/user.dart';
import 'package:our_voice/providers/artProvider.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:our_voice/services/database.dart';
import 'package:our_voice/widgets/canvasViewWidget.dart';
import 'package:our_voice/widgets/commentsViewWidget.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends StatefulWidget {
  final String uid;
  const UserProfile({super.key, required this.uid});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
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
        stream: Database().loadusr(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> user = [];
            for (var doc in snapshot.data!.docs) {
              var data = doc;
              user.add(User(
                profilePicture:
                    data.data().toString().contains('profile_picture')
                        ? doc.get('profile_picture')
                        : "",
                coverPicture: data.data().toString().contains('cover_picture')
                    ? doc.get('cover_picture')
                    : "",
                postalcode: data.data().toString().contains('postalcode')
                    ? doc.get('postalcode')
                    : "",
                canvas: data.data().toString().contains('canvas')
                    ? doc.get('canvas')
                    : "",
                pending: data.data().toString().contains('pending')
                    ? doc.get('pending')
                    : "",
                showphone: data.data().toString().contains('showphone')
                    ? doc.get('showphone')
                    : "",
                praise: data.data().toString().contains('praise')
                    ? doc.get('praise')
                    : "",
                phone: data.data().toString().contains('phone')
                    ? doc.get('phone')
                    : "",
                filled: data.data().toString().contains('filled')
                    ? doc.get('filled')
                    : "",
                email: data.data().toString().contains('email')
                    ? doc.get('email')
                    : "",
                gender: data.data().toString().contains('gender')
                    ? doc.get('gender')
                    : "",
                usertype: data.data().toString().contains('usertype')
                    ? doc.get('usertype')
                    : "",
                username: data.data().toString().contains('username')
                    ? doc.get('username')
                    : "",
                uid: data.data().toString().contains('uid')
                    ? doc.get('uid')
                    : "",
                fullname: data.data().toString().contains('fullname')
                    ? doc.get('fullname')
                    : "",
                critic: data.data().toString().contains('critic')
                    ? doc.get('critic')
                    : "",
                birthdate: data.data().toString().contains('birthdate')
                    ? doc.get('birthdate')
                    : "",
                city: data.data().toString().contains('city')
                    ? doc.get('city')
                    : "",
                bio: data.data().toString().contains('bio')
                    ? doc.get('bio')
                    : "",
              ));
            }
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
                              user[0].coverPicture,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  user[0].profilePicture,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
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
                                      user[0].fullname,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: MainButton(
                                    text: "Follow",
                                    onTap: () {},
                                    hasCircularBorder: true,
                                  ),
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
                          Text(user[0].followers.length.toString()),
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
                          Text(user[0].followings.length.toString()),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        onTap: (index) {
                          print(index);
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
                      Builder(builder: (_) {
                        if (_selectedTabbar == 0) {
                          return StreamBuilder(
                            stream: Database().loadmyart(user[0].uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Consumer<ArtProvider>(
                                  builder: (context, value, child) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: value.myart.length,
                                      itemBuilder: (context, index) =>
                                          CanvasViewWidget(
                                        art: value.myart[index],
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
                          return StreamBuilder<QuerySnapshot>(
                            stream: Database().loadcmnt(user[0].uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Comment> cmnt = [];
                                for (var doc in snapshot.data!.docs) {
                                  var data = doc;
                                  cmnt.add(
                                    Comment(
                                      artId: data
                                              .data()
                                              .toString()
                                              .contains('ArtID')
                                          ? doc.get('ArtID')
                                          : "",
                                      commentor: data
                                              .data()
                                              .toString()
                                              .contains('Commentor')
                                          ? doc.get('Commentor')
                                          : "",
                                      url:
                                          data.data().toString().contains('url')
                                              ? doc.get('url')
                                              : "",
                                      praises: data
                                              .data()
                                              .toString()
                                              .contains('praises')
                                          ? doc.get('praises')
                                          : "",
                                      critics: data
                                              .data()
                                              .toString()
                                              .contains('critics')
                                          ? doc.get('critics')
                                          : "",
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cmnt.length,
                                  itemBuilder: (context, index) =>
                                      CommentsViewWidget(
                                    comment: Comment(
                                      artId: cmnt[index].artId,
                                      commentor: cmnt[index].commentor,
                                      url: cmnt[index].url,
                                      praises: cmnt[index].praises,
                                      critics: cmnt[index].critics,
                                    ),
                                  ),
                                );
                              }
                              return Center(
                                child: MainPageState.loadingWidget,
                              );
                            },
                          );
                        }
                      }),
                    ],
                  ),
                ],
              ),
            );
          }
          return MainPageState.loadingWidget;
        },
      ),
    ));
  }
}
