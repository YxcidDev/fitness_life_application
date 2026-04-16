import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'settings_item.dart';
 
class SettingsSection extends StatelessWidget {
  final String label;
  final List<SettingsItem> items;
 
  const SettingsSection({super.key, required this.label, required this.items});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(label,
                style: const TextStyle(
                    color: kGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
          ...items,
        ],
      ),
    );
  }
}