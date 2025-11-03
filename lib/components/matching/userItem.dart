import 'package:flutter/material.dart';
import 'package:projet_ia/services/matching.dart';
import 'package:projet_ia/services/invitation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/classes/maching_guest_input.dart';
import 'package:projet_ia/components/empty_list.dart';
import 'package:projet_ia/components/toast.dart';
// import './chat.dart';
import "package:projet_ia/components/matching/show_details.dart";
import "package:projet_ia/utils.dart";

//
// 3️⃣ LIST SCREEN
//

class UserItem extends StatefulWidget {
  final dynamic user;
  List<Widget>? actions = [];
  UserItem({super.key, required this.user, this.actions});

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    dynamic user = widget.user;
    final age =
        user['dateOfBirth'] != null
            ? "${calculateAge(user['dateOfBirth'])} ans"
            : "Non renseigné";
    final profileImagePath =
        user["profileImagePath"] != null
            ? user["profileImagePath"]
            : user["user_info"] != null &&
                user["user_info"]![0] != null &&
                user["user_info"]![0]!["imageProfile"] != null
            ? user["user_info"]![0]!["imageProfile"]
            : "";

    return GestureDetector(
      onTap: () => showUserDetailModal(context, widget.user),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          leading:
              profileImagePath == ""
                  ? const CircleAvatar(child: Icon(Icons.person))
                  : CircleAvatar(
                    backgroundImage: NetworkImage(profileImagePath),
                  ),
          title: Text(
            "${user['name'] ?? user['pseudo']}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${age} • ${user['country'] ?? 'Non renseigné'} • ${user['sexe'] ?? 'Non renseigné'} ",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.actions != [] ? widget.actions! : [],
            // [
            //   IconButton(
            //     icon: const Icon(
            //       Icons.person_add_alt_outlined,
            //       color: Colors.blueAccent,
            //     ),
            //     onPressed: () async {
            //       // String invitation_id = await invitationService.sendInvitation(
            //       //   uniqueId,
            //       //   MachingGuestInput(
            //       //     guest_id: user["user_id"],
            //       //     guest_resume: user["resume"],
            //       //     compatibility_score:
            //       //         matching_result['compatibility_score'],
            //       //     reason: matching_result["reason"],
            //       //     advice: matching_result["advice"],
            //       //   ),
            //       // );
            //       // if (invitation_id.isNotEmpty) {
            //       //   toastNotification(context, "Invitation envoyée 💌");
            //       //   setState(() {
            //       //     users.remove(cursor);
            //       //   });
            //       // } else {
            //       //   toastNotification(
            //       //     context,
            //       //     "Echec d'envoie d'invitation, veuiller réssayer svp",
            //       //   );
            //       // }
            //     },
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}
