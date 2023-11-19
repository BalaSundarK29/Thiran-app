import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:negup/pages/add_ticket.dart';
import 'package:negup/pages/home_screen.dart';

import '../pages/splash_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: GlobalKey(),
    debugLogDiagnostics: true,
    initialLocation: SplashPage.routeLocation,
    routes: [
      GoRoute(
        path: '/',
        name: SplashPage.routeName,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: HomePage.routeLocation,
        name: HomePage.routeName,
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: AddTicket.routeLocation,
        name: AddTicket.routeName,
        builder: (context, state) {
          return AddTicket();
        },
      ),
    ],
   
  );
});
