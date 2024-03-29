import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';
import 'main.dart';

class RightScreen extends StatelessWidget {
  const RightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SwipeScreen(
      key: UniqueKey(),
      swipeFromLeft: const SwipeTransition(
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
        switch (direction) {
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
