

import 'package:flutter/material.dart';

class MenuOption{
  final String route;
  final IconData icon;
  final String name;
  final Widget screen;
  final Map? args;

  MenuOption({
    required this.route,
    required this.icon,
    required this.name,
    required this.screen,
    this.args
  });
}