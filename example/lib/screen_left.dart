import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';

import 'main.dart';

class LeftScreen extends StatefulWidget {
  const LeftScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LeftScreenState();
}

class _LeftScreenState extends State<LeftScreen> {

  final SwipeMovement _movement = SwipeMovement();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SwipeScreen(
        key: UniqueKey(),
        movement: _movement,
        swipeFromRight: const SwipeTransition(
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
          switch (direction) {
            case SwipeDirection.fromRight:
              Navigator.of(context).pop();
              break;
            default:
              break;
          }
        },
      ),
      onWillPop: () async {
        setState(() {
          _movement.startTransition(SwipeDirection.fromRight);
        });
        return false;
      },
    );
  }
}
