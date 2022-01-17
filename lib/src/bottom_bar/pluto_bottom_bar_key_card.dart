import 'package:flutter/material.dart';

class KeyCard extends StatelessWidget {
  final String char;
  final VoidCallback onTap;

  const KeyCard({
    Key? key,
    required this.char,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Center(
              child: Text(
            char,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }
}
