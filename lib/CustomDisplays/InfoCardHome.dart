import 'package:flutter/material.dart';

// Custom reusable widget with click handler
class InfoCardHome extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const InfoCardHome({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, size: 40),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
        ),
      ),
    );
  }
}