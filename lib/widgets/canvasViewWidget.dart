import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class CanvasViewWidget extends StatelessWidget {
  const CanvasViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 5,
                offset: const Offset(1, 1))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25.h,
              decoration: BoxDecoration(
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
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/our-action-62ab6.appspot.com/o/images%2FDjamel231.jpg?alt=media&token=16323c94-1ff0-4467-a3de-5d21606e3d26"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: SizedBox(
                      child: Text(
                        "Artwork Name that's so tall",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.thumbsUp,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("5"),
                    ],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: Row(
            //     children: const [
            //       CircleAvatar(
            //         radius: 20,
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Text("Artist Name")
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
