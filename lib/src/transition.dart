library swipe_screen;

/*
  Copyright 2022 Ka10008 All rights reserved.
  Released under the MIT License
  https://opensource.org/licenses/MIT
 */

import 'package:flutter/material.dart';

enum TransitionType {
  push,
  pop,
  none,
}

class SwipeTransition {
  const SwipeTransition({
    required this.screen,
    required this.transitionType,
  });

  /// A widget that creates a screen that transitions with a swipe.
  final Widget screen;

  /// A type of transition by swiping the screen.
  ///
  /// If [TransitionType.push] is assigned,
  /// the transition is made so that the destination screen overlaps the current screen.
  ///
  /// If [TransitionType.pop] is assigned,
  /// the screen to be transitioned to is displayed from below of the current screen.
  ///
  /// If [TransitionType.none]is assigned,
  /// the screen does not transition when swiping.
  final TransitionType transitionType;
}
