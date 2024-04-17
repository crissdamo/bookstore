import 'package:flutter/material.dart';

class BotaoLargo extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const BotaoLargo({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
        child: SizedBox(
          width: double.maxFinite,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
            label: Text(text,
                style: const TextStyle(color: Colors.black, fontSize: 20)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
