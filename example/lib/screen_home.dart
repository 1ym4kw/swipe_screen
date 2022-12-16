import 'package:example/screen_bottom.dart';
import 'package:example/screen_left.dart';
import 'package:example/screen_right.dart';
import 'package:example/screen_top.dart';
import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';





class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwipeScreen(
      key: UniqueKey(),
      swipeFromLeft: SwipeTransition(
        screen: LeftScreen(),
        transitionType: TransitionType.push,
      ),
      swipeFromTop: SwipeTransition(
        screen: TopScreen(),
        transitionType: TransitionType.push,
      ),
      swipeFromRight: SwipeTransition(
        screen: RightScreen(),
        transitionType: TransitionType.push,
      ),
      swipeFromBottom: SwipeTransition(
        screen: BottomScreen(),
        transitionType: TransitionType.push,
      ),
      currentScreenBuilder: (ScrollController controller) {
        return const Scaffold(
          body: Center(
            child: Text(
              'HomeScreen',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
        );
      },
      onSwiped: (direction) {
        switch(direction) {
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