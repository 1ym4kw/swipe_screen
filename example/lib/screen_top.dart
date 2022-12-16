import 'package:example/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';





class TopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwipeScreen(
      key: UniqueKey(),
      swipeFromBottom: SwipeTransition(
        screen: HomeScreen(),
        transitionType: TransitionType.pop,
      ),
      currentScreenBuilder: (ScrollController controller) {
        return Scaffold(
          backgroundColor: Colors.yellow.shade100,
          body: const Center(
            child: Text(
              'TopScreen',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
        );
      },
      onSwiped: (direction) {
        switch(direction) {
          case SwipeDirection.fromBottom:
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      },
    );
  }
}