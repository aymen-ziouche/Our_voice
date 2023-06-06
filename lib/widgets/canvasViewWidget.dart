import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:our_voice/modules/art.dart';
import 'package:our_voice/providers/ownerProvider.dart';
import 'package:our_voice/screens/detailsPage.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:our_voice/widgets/ownerWidget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CanvasViewWidget extends StatelessWidget {
  final Art art;
  const CanvasViewWidget({
    super.key,
    required this.art,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                art: art,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 3,
                  offset: const Offset(1, 5))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 25.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 5,
                          offset: const Offset(1, 1))
                    ],
                    borderRadius: BorderRadius.circular(10).copyWith(
                      bottomLeft: const Radius.circular(0),
                      bottomRight: const Radius.circular(0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      art.image,
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
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0).copyWith(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        child: Text(
                          art.name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.leaf,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(art.critics.length.toString()),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.fire,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(art.praises.length.toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ChangeNotifierProvider(
                  create: (context) => OwnerProvider(art.ownerId),
                  child: const OwnerWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
