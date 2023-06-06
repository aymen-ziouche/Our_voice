import 'package:flutter/material.dart';
import 'package:our_voice/providers/ownerProvider.dart';
import 'package:our_voice/screens/profile/userProfile.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:provider/provider.dart';

class OwnerWidget extends StatelessWidget {
  const OwnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerProvider = Provider.of<OwnerProvider>(context);
    final owner = ownerProvider.user;
    return owner == null
        ? const Text("loading Artist ...")
        : InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(uid: owner.uid),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(owner.profilePicture),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            owner.fullname,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            owner.username,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 80,
                    height: 40,
                    child: MainButton(
                      text: "Follow",
                      onTap: () {},
                      hasCircularBorder: true,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
