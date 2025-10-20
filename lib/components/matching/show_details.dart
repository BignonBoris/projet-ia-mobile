import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import "package:projet_ia/services/invitation.dart";
import 'package:projet_ia/classes/maching_guest_input.dart';

void showUserDetailModal(BuildContext context, Map<String, dynamic> cursor) {
  final InvitationService invitationService = InvitationService();

  final user = cursor["user"] ?? cursor;
  final matching_result = cursor["result"] ?? cursor;
  final age = user['age'] != null ? "${user['age']} ans" : "Non renseigné";
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // pour laisser voir le dégradé
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // taille de départ
        minChildSize: 0.4,
        maxChildSize: 0.8,
        expand: false,
        builder:
            (_, controller) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.pink),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'] ?? "Non renseigné",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${age} • ${user['city'] ?? 'Non renseigné'}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "À propos :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    data: user["resume"] ?? '',
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context),
                    ).copyWith(
                      p: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  const Text(
                    "Votre compatibilité :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    matching_result["reason"] ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "recommandation :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    matching_result["advice"] ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text("Démarrer une discussion"),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        String uniqueId =
                            prefs.getString('onboarding_done') ?? "";
                        // Navigator.pop(context);
                        String invitation_id = await invitationService
                            .sendInvitation(
                              uniqueId,
                              MachingGuestInput(
                                guest_id: user["user_id"],
                                guest_resume: user["resume"],
                                compatibility_score:
                                    matching_result['compatibility_score'],
                                reason: matching_result["reason"],
                                advice: matching_result["advice"],
                              ),
                            );
                        print(invitation_id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invitation envoyée 💌"),
                          ),
                        );
                        // 👉 Naviguer vers le chat
                      },
                    ),
                  ),
                ],
              ),
            ),
      );
    },
  );
}
