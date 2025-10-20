import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/settings_provider.dart';

class Message extends StatefulWidget {
  final String role;
  final String message;
  final bool isTyping;
  const Message({
    Key? key,
    required this.message,
    required this.role,
    this.isTyping = false,
  }) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Widget build(BuildContext context) {
    var settingsProvider = context.watch<SettingsProvider>();
    bool isNotUser = widget.role != "user";
    bool isSystem = widget.role == "system";

    return Align(
      alignment:
          isSystem
              ? Alignment.center
              : isNotUser
              ? Alignment.centerLeft
              : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: isSystem ? const EdgeInsets.all(8) : const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSystem
                  ? Colors.grey[300]
                  : isNotUser
                  ? widget.isTyping
                      ? Colors.transparent
                      : settingsProvider.aiMessageBgColor
                  : settingsProvider.userMessageBgColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isSystem
                    ? const Radius.circular(12)
                    : isNotUser
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
            bottomRight:
                isSystem
                    ? const Radius.circular(12)
                    : isNotUser
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
          ),
          // border: Border.all(
          //   color: Colors.pink,
          //   width: 2,
          // ),
        ),
        child: MarkdownBody(
          data:
              widget.isTyping
                  ? widget.message
                  : widget.message[0].toUpperCase() +
                      widget.message.substring(1),
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: TextStyle(
              fontSize: isSystem ? 10 : 14,
              color:
                  isSystem
                      ? Colors.black
                      : isNotUser
                      ? settingsProvider.aiMessageColor
                      : settingsProvider
                          .userMessageColor, // 👈 couleur choisie dans paramètres
            ),
          ),
        ),
      ),
    );
  }
}
