import 'package:flutter/material.dart';

class HomeSubScaffold extends StatelessWidget {
  const HomeSubScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottomNavigationBar,
    this.showBackButton = true,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),

      body: SafeArea(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
