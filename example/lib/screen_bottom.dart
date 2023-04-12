import 'package:flutter/material.dart';
import 'package:swipe_screen/swipe_screen.dart';
import 'main.dart';

class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SwipeScreen(
      key: UniqueKey(),
      swipeFromTop: const SwipeTransition(
        screen: HomeScreen(),
        transitionType: TransitionType.pop,
      ),
      currentScreenBuilder: (ScrollController controller) {
        return Scaffold(
          backgroundColor: Colors.purple.shade100,
          body: ListView(
            controller: controller,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
              ),
              const Center(
                child: Text(
                  'BottomScreen',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
              Container(
                height: 160,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  'This screen is scrollable. If the current screen is scrollable, [isScrollEnable] should be true.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 320,
              ),
              const Center(
                child: Text(
                  '↓ Scrollable ↑',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                height: 320,
              ),
              const Center(
                child: Text(
                  '↓ Scrollable ↑',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                height: 320,
              ),
              const Center(
                child: Text(
                  '↓ Scrollable ↑',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                height: 320,
              ),
              const Center(
                child: Text(
                  'Scroll Ended ↑',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      isScrollEnable: true,
      onSwiped: (direction) {
        switch (direction) {
          case SwipeDirection.fromTop:
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      },
    );
  }
}
