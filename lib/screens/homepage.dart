import 'package:flutter/material.dart';
import 'package:our_voice/providers/userprovider.dart';
import 'package:our_voice/screens/auth/signin_screen.dart';
import 'package:our_voice/services/auth.dart';
import 'package:our_voice/widgets/canvasViewWidget.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15).copyWith(bottom: 1),
            child: Text(
              "Artworks:",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.4),
            ),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return const CanvasViewWidget();
            },
          ),
          MainButton(
            text: 'Log Out',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SigninPage()),
                (Route<dynamic> route) => false,
              );
              Auth().logout();
            },
          ),
          // SizedBox(
          //   height: 200,
          //   child: Consumer<CanvasProvider>(
          //     builder: (context, provider, child){
          //       return PageView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: pagedata.maindata.topspaces.length,
          //         controller: PageController(
          //           initialPage: pagedata.maindata.topspaces.length ~/ 2,
          //           viewportFraction: 0.8,
          //         ),
          //         itemBuilder: (BuildContext context, int index) {
          //           return CanvasViewWidget(
          //             // topspacedata: pagedata.maindata.topspaces[index],
          //           );
          //         },
          //       );
          //     }
          //   ),
          // ),
        ],
      ),
    );
  }
}
