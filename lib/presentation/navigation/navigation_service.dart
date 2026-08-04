import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> push<T>(Route<T> route) async {
    return navigatorKey.currentState?.push(route);
  }

  Future<T?> pushWidget<T>(Widget page) async {
    return navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));
  }
}
