import 'package:flutter/material.dart';

class AppearanceSettingWidget extends StatelessWidget {
  const AppearanceSettingWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.onSelected,
  });
  final bool isSelected;
  final String title;
  final IconData icon;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 8.0),
              Text(title),
              const SizedBox(height: 24.0),
              Icon(
                key: const Key('selected_icon'),
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Colors.blueAccent : Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
