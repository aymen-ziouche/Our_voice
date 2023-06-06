import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:our_voice/modules/art.dart';
import 'package:our_voice/modules/comment.dart';
import 'package:our_voice/providers/artProvider.dart';
import 'package:our_voice/providers/commentsProvider.dart';
import 'package:our_voice/providers/userprovider.dart';
import 'package:our_voice/services/database.dart';
import 'package:our_voice/widgets/canvasViewWidget.dart';
import 'package:our_voice/widgets/commentsViewWidget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.fetchUser();
    final artProvider = context.read<ArtProvider>();
    artProvider.fetchArts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.4)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: 'Search Artworks, Artist and much more',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Consumer<CommentsProvider>(builder: (context, provider, child) {
          //   return ListView.builder(
          //     physics: const NeverScrollableScrollPhysics(),
          //     shrinkWrap: true,
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     itemCount: provider.comments.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       Comment comment = provider.comments[index];
          //       return CommentsViewWidget(
          //         comment: comment,
          //       );
          //     },
          //   );
          // }),
          StreamBuilder(
            stream: Database().loadComments(),
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
                      commentor: data.data().toString().contains('Commentor')
                          ? doc.get('Commentor')
                          : "",
                      url: data.data().toString().contains('url')
                          ? doc.get('url')
                          : "",
                      praises: data.data().toString().contains('praises')
                          ? doc.get('praises')
                          : "",
                      critics: data.data().toString().contains('critics')
                          ? doc.get('critics')
                          : "",
                    ),
                  );
                }
                return SizedBox(
                  height: 23.h,
                  child: PageView.builder(
                    controller: PageController(
                      initialPage: cmnt.length ~/ 2,
                      viewportFraction: 0.8,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: cmnt.length,
                    itemBuilder: (context, index) => CommentsViewWidget(
                      comment: Comment(
                          artId: cmnt[index].artId,
                          commentor: cmnt[index].commentor,
                          url: cmnt[index].url,
                          praises: cmnt[index].praises,
                          critics: cmnt[index].critics),
                    ),
                  ),
                );
              }
              return const Center(
                child: Text("Loading..."),
              );
            },
          ),
          Consumer<ArtProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: provider.arts.length,
                itemBuilder: (BuildContext context, int index) {
                  Art art = provider.arts[index];
                  return CanvasViewWidget(
                    art: art,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
