library swipe_screen;

/*
  Copyright 2022 Ka10008 All rights reserved.
  Released under the MIT License
  https://opensource.org/licenses/MIT
 */

import 'swipe_screen.dart';

class SwipeMovement {
  SwipeDirection _direction = SwipeDirection.none;

  SwipeDirection get direction {
    return _direction;
  }

  void startTransition(SwipeDirection direction) {
    _direction = direction;
  }
}
