import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:negup/providers/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  final Curve _curve = Curves.easeInOut;
  static String get routeName => 'splash';
  static String get routeLocation => '/';
  const SplashPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<SplashPage> {
  double loginWidth = 0.0;
  @override
  void initState() {
    super.initState();
    doAnimation();
    initTimer();
  }

  void initTimer() {
    Future.delayed(const Duration(seconds: 3), () {
       context.go('/home');
     // GoRouter.of(context).push('/home');
    });
  }

  void doAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      ref.read(spProvider.notifier).state == 0.0
          ? ref.read(spProvider.notifier).state =
              MediaQuery.of(context).size.width * 0.85
          : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultval = ref.watch(spProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: widget._curve,
                width: resultval,
                height: 100,
                child: Image.asset(
                  "assets/applogo.jpg",
                  width: resultval,
                ))
          ],
        ),
      ),
    );
  }
}
