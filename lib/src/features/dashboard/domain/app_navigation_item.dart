import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum AppNavigationItem {
  home(
    labelKey: 'navigation.home',
    icon: Icons.home,
    branchIndex: 0,
    sectionKey: 'navigation.section_menu',
  ),
  downloads(
    labelKey: 'navigation.downloads',
    icon: Icons.download,
    branchIndex: 1,
    sectionKey: 'navigation.section_library',
  ),
  recent(
    labelKey: 'navigation.recent',
    icon: Icons.schedule,
    branchIndex: 2,
    sectionKey: 'navigation.section_library',
  ),
  settings(
    labelKey: 'navigation.settings',
    icon: Icons.settings,
    branchIndex: 3,
    sectionKey: 'navigation.section_general',
  );

  final String labelKey;
  final IconData icon;
  final int branchIndex;
  final String sectionKey;

  const AppNavigationItem({
    required this.labelKey,
    required this.icon,
    required this.branchIndex,
    required this.sectionKey,
  });

  String get localizedLabel => tr(labelKey);
  String get localizedSection => tr(sectionKey);

  static AppNavigationItem? fromBranchIndex(int index) {
    try {
      return AppNavigationItem.values.firstWhere(
        (item) => item.branchIndex == index,
      );
    } catch (_) {
      return null;
    }
  }
}
