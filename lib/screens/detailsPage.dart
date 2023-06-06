import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:our_voice/modules/art.dart';
import 'package:our_voice/modules/comment.dart';
import 'package:our_voice/providers/ownerProvider.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:our_voice/screens/recording/recordForm.dart';
import 'package:our_voice/services/auth.dart';
import 'package:our_voice/services/database.dart';
import 'package:our_voice/widgets/canvasViewWidget.dart';
import 'package:our_voice/widgets/commentsViewWidget.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:our_voice/widgets/ownerWidget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';

class DetailsPage extends StatefulWidget {
  final Art art;
  const DetailsPage({super.key, required this.art});
  static String id = "DetailsPage";

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  int selectedDL = 0;
  TabController? tabController;

  @override
  void initState() {
    // TODO: implement initState
    tabController =
        TabController(initialIndex: selectedDL, length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final user = _auth.currentUser;

    int praise = widget.art.praises.length;
    int critics = widget.art.critics.length;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0,
          scrolledUnderElevation: 0,
          actions: [
            widget.art.ownerId == user!.uid
                ? PopupMenuButton(
                    itemBuilder: (context) =>
                        [PopupMenuItem(value: 'delete', child: Text("delete"))],
                    onSelected: (value) {
                      if (value == 'delete') {
                        Future<void> delete(String artId) async {
                          final artQuerySnapshot = await FirebaseFirestore
                              .instance
                              .collection('Art')
                              .where('artId', isEqualTo: artId)
                              .limit(1)
                              .get();

                          if (artQuerySnapshot.docs.isNotEmpty) {
                            final artDoc = artQuerySnapshot.docs.first;
                            final artDocId = artDoc.id;
                            print(artDocId);
                            if (artDoc.get('ownerId') == user.uid) {
                              await FirebaseFirestore.instance
                                  .collection('Art')
                                  .doc(artDocId)
                                  .delete();

                              print('Art deleted successfully');
                              Navigator.pop(context);
                            } else {
                              print(
                                  'You do not have permission to delete this art');
                            }
                          } else {
                            print('Art not found');
                          }
                        }

                        delete(widget.art.artId);
                      }
                    },
                  )
                : SizedBox()
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 40.h,
                    width: 100.w,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        widget.art.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: MainPageState.loadingWidgetSmall,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 10.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.5),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Text(
                                widget.art.name,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Database().praise(widget.art.artId);
                                    setState(() {
                                      praise += 1;
                                    });
                                    print("liked");
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.leaf,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        praise.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                   
                                    Database().critics(widget.art.artId);
                                    setState(() {
                                      critics += 1;
                                    });
                                    print("critics");
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.fire,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        critics.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ChangeNotifierProvider(
                create: (context) => OwnerProvider(widget.art.ownerId),
                child: const OwnerWidget(),
              ),
              widget.art.toSell == true
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: SizedBox(
                              child: MainButton(
                                  text:
                                      "Buy for ${widget.art.price.toInt()} ${widget.art.currency.trim()}",
                                  onTap: () {
                                    //TODO: TAKE the user to checkout page
                                  },
                                  hasCircularBorder: true),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Description :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
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
                    const Divider(height: 0, endIndent: 0),
                    IndexedStack(
                      index: selectedDL,
                      children: [
                        Visibility(
                            maintainState: true,
                            visible: selectedDL == 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(widget.art.descriptionEn),
                            )),
                        Visibility(
                            maintainState: true,
                            visible: selectedDL == 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(widget.art.descriptionAr),
                            )),
                        Visibility(
                            maintainState: true,
                            visible: selectedDL == 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(widget.art.descriptionFr),
                            )),
                        Visibility(
                            maintainState: true,
                            visible: selectedDL == 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(widget.art.descriptionSp),
                            )),
                        Visibility(
                            maintainState: true,
                            visible: selectedDL == 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(widget.art.descriptionGr),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Date Created :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(DateFormat('yyyy-MM-dd')
                        .format(widget.art.dateCreated)
                        .toString()),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Type of Copy :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(widget.art.type),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Size (cm) :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                        "${widget.art.height} * ${widget.art.width} * ${widget.art.length}"),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              StickyHeader(
                header: Container(
                  padding: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5);
                                }
                                return const Color(
                                    0xFF54C0E9); // Use the component's default.
                              },
                            ),
                            shape: MaterialStateProperty.resolveWith<
                                OutlinedBorder>((Set<MaterialState> states) {
                              return const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                    right: Radius.circular(10)),
                              );
                            }),
                            minimumSize:
                                MaterialStateProperty.resolveWith<Size>(
                                    (Set<MaterialState> states) {
                              return Size(15.w, 7.w);
                            }),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) => RecordForm(
                                ctx: ctx,
                                artId: widget.art.artId,
                                uid: Auth().currentUser!.uid,
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          },
                          child: const Text(
                            'ADD',
                            style: TextStyle(
                              letterSpacing: -0.24,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                content: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Database().loadcmnt(widget.art.artId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Comment> cmnt = [];
                        for (var doc in snapshot.data!.docs) {
                          var data = doc;
                          cmnt.add(
                            Comment(
                              artId: data.data().toString().contains('ArtID')
                                  ? doc.get('ArtID')
                                  : "",
                              commentor:
                                  data.data().toString().contains('Commentor')
                                      ? doc.get('Commentor')
                                      : "",
                              url: data.data().toString().contains('url')
                                  ? doc.get('url')
                                  : "",
                              praises:
                                  data.data().toString().contains('praises')
                                      ? doc.get('praises')
                                      : "",
                              critics:
                                  data.data().toString().contains('critics')
                                      ? doc.get('critics')
                                      : "",
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: cmnt.length,
                          itemBuilder: (context, index) => CommentsViewWidget(
                            comment: Comment(
                                artId: cmnt[index].artId,
                                commentor: cmnt[index].commentor,
                                url: cmnt[index].url,
                                praises: cmnt[index].praises,
                                critics: cmnt[index].critics),
                          ),
                        );
                      }
                      return const Center(
                        child: Text("Loading..."),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
