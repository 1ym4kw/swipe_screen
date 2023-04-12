import 'package:example/screen_bottom.dart';
import 'package:example/screen_left.dart';
import 'package:example/screen_right.dart';
import 'package:example/screen_top.dart';
import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SwipeScreen',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final SwipeMovement _movement = SwipeMovement();
  
  @override
  Widget build(BuildContext context) {
    return SwipeScreen(
      key: UniqueKey(),
      movement: _movement,
      swipeFromLeft: const SwipeTransition(
        screen: LeftScreen(),
        transitionType: TransitionType.push,
      ),
      swipeFromTop: const SwipeTransition(
        screen: TopScreen(),
        transitionType: TransitionType.push,
      ),
      swipeFromRight: const SwipeTransition(
        screen: RightScreen(),
        transitionType: TransitionType.push,
      ),
      swipeFromBottom: const SwipeTransition(
        screen: BottomScreen(),
        transitionType: TransitionType.push,
      ),
      currentScreenBuilder: (ScrollController controller) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'HomeScreen',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _movement.startTransition(SwipeDirection.fromLeft);
                    });
                  }, 
                  child: const Text(
                    'to LeftScreen',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _movement.startTransition(SwipeDirection.fromBottom);
                    });
                  },
                  child: const Text(
                    'to BottomScreen',
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onSwiped: (direction) {
        switch (direction) {
          case SwipeDirection.fromLeft:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => LeftScreen(),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
            break;
          case SwipeDirection.fromTop:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TopScreen(),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
            break;
          case SwipeDirection.fromRight:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => RightScreen(),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
            break;
          case SwipeDirection.fromBottom:
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => BottomScreen(),
                transitionDuration: const Duration(seconds: 0),
              ),
            );
            break;
          case SwipeDirection.none:
            break;
        }
      },
    );
  }
}
