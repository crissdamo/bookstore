import 'package:flutter/material.dart';

class BotaoCurto extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const BotaoCurto({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
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
      ],
    );
  }
}
