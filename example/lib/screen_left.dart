import 'package:example/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';





class LeftScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwipeScreen(
      key: UniqueKey(),
      swipeFromRight: SwipeTransition(
        screen: HomeScreen(),
        transitionType: TransitionType.pop,
      ),
      currentScreenBuilder: (ScrollController controller) {
        return Scaffold(
          backgroundColor: Colors.red.shade100,
          body: const Center(
            child: Text(
              'LeftScreen',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
        );
      },
      onSwiped: (direction) {
        switch(direction) {
          case SwipeDirection.fromRight:
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      },
    );
  }
}