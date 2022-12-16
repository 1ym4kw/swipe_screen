import 'package:example/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';





class RightScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwipeScreen(
      key: UniqueKey(),
      swipeFromLeft: SwipeTransition(
        screen: HomeScreen(),
        transitionType: TransitionType.pop,
      ),
      currentScreenBuilder: (ScrollController controller) {
        return Scaffold(
          backgroundColor: Colors.green.shade100,
          body: const Center(
            child: Text(
              'RightScreen',
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
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      },
    );
  }
}