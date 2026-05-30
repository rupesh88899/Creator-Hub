// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/src/notch_bottom_bar.dart';
import 'package:animated_notch_bottom_bar/src/notch_bottom_bar_controller.dart';
import 'package:animated_notch_bottom_bar/src/models/bottom_bar_item_model.dart';
import '../core/theme/app_theme.dart';

class FloatingBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingBottomNav> createState() => _FloatingBottomNavState();
}

class _FloatingBottomNavState extends State<FloatingBottomNav> {
  late final NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: widget.currentIndex);
  }

  @override
  void didUpdateWidget(FloatingBottomNav old) {
    super.didUpdateWidget(old);
    if (widget.currentIndex != old.currentIndex) {
      _controller.jumpTo(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding + 12),
      child: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.feed, color: AppTheme.textSecondary),
            activeItem: Icon(Icons.feed, color: Colors.white),
            itemLabel: 'Feed',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.chat, color: AppTheme.textSecondary),
            activeItem: Icon(Icons.chat, color: Colors.white),
            itemLabel: 'Chat',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.shopping_bag, color: AppTheme.textSecondary),
            activeItem: Icon(Icons.shopping_bag, color: Colors.white),
            itemLabel: 'Products',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: AppTheme.textSecondary),
            activeItem: Icon(Icons.person, color: Colors.white),
            itemLabel: 'Profile',
          ),
        ],
        onTap: widget.onTap,
        kIconSize: 22,
        kBottomRadius: 28,
        color: Colors.white,
        notchColor: AppTheme.primaryColor,
        showLabel: true,
        itemLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppTheme.textSecondary,
        ),
        showShadow: false,
        bottomBarHeight: 70,
        durationInMilliSeconds: 300,
        removeMargins: false,
      ),
    );
  }
}
