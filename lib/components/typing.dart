import 'package:flutter/material.dart';
import 'package:projet_ia/components/message.dart';

class TypingLoader extends StatefulWidget {
  const TypingLoader({Key? key}) : super(key: key);

  @override
  State<TypingLoader> createState() => _TypingLoaderState();
}

class _TypingLoaderState extends State<TypingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _dotsAnimation = IntTween(
      begin: 0,
      end: 3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotsAnimation,
      builder: (context, child) {
        String dots = '.' * _dotsAnimation.value;
        return Message(message: dots, role: "assitant", isTyping: true);
        // return Align(
        //   alignment: Alignment.centerLeft,
        //   child: Container(
        //     margin: const EdgeInsets.symmetric(vertical: 4),
        //     padding: const EdgeInsets.all(4),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.only(
        //         topLeft: const Radius.circular(12),
        //         topRight: const Radius.circular(12),
        //         bottomLeft: const Radius.circular(0),
        //         bottomRight: const Radius.circular(12),
        //       ),
        //       border: Border.all(color: Colors.pink, width: 2),
        //     ),
        //     child: Text(
        //       "$dots",
        //       textAlign: TextAlign.justify,
        //       style: const TextStyle(
        //         fontSize: 20,
        //         fontStyle: FontStyle.italic,
        //         color: Colors.pinkAccent,
        //       ),
        //     ),
        //   ),
        // ); // safe fallback
      },
    );
  }
}
