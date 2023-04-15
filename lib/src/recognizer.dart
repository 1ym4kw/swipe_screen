library swipe_screen;

/*
  Copyright 2022 Ka10008 All rights reserved.
  Released under the MIT License
  https://opensource.org/licenses/MIT
 */

import 'package:flutter/material.dart';

typedef SwipeStartCallback = void Function(
    PointerMoveEvent event, bool isHorizontal);
typedef SwipeUpdateCallback = void Function(PointerMoveEvent event);

class SwipeRecognizer extends StatefulWidget {
  const SwipeRecognizer({
    Key? key,
    this.onSwipeStart,
    this.onSwipeUpdate,
    this.onSwipeEnd,
    required this.child,
  }) : super(key: key);

  final SwipeStartCallback? onSwipeStart;
  final SwipeUpdateCallback? onSwipeUpdate;
  final VoidCallback? onSwipeEnd;
  final Widget child;

  @override
  State<SwipeRecognizer> createState() => _SwipeRecognizerState();
}

class _SwipeRecognizerState extends State<SwipeRecognizer> {
  late bool _isHorizontal;
  late int _recognized;
  late bool _isStartCalled;
  late double _extent;
  late bool _isLongPress;
  final Stopwatch _timer = Stopwatch();

  void _onPointerDown(PointerDownEvent event) {
    _recognized = 0;
    _isStartCalled = false;
    _extent = 0;
    _isLongPress = false;
    _timer.start();
  }

  void _onPointerMove(PointerMoveEvent event) {
    final deltaX = event.localDelta.dx;
    final deltaY = event.localDelta.dy;
    if (deltaX == 0 && deltaY == 0) {
      return;
    }
    if (_extent == 0) {
      if (deltaX.abs() > deltaY.abs()) {
        _isHorizontal = true;
      } else {
        _isHorizontal = false;
      }
    }
    _extent += _isHorizontal ? deltaX : deltaY;
    if (_extent.abs() >= 20) {
      _recognized += 1;
    }
    if (_recognized == 0) {
      final elapsed = _timer.elapsed.inMilliseconds;
      if (elapsed >= 700) {
        _isLongPress = true;
      }
      return;
    }
    if (_isLongPress) {
      _timer.reset();
      _recognized = 0;
      return;
    }
    if (!_isStartCalled) {
      if (widget.onSwipeStart != null) {
        widget.onSwipeStart!.call(event, _isHorizontal);
      }
      _isStartCalled = true;
    } else {
      if (widget.onSwipeUpdate != null) {
        widget.onSwipeUpdate!.call(event);
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _timer.reset();
    if (_recognized == 0) {
      return;
    }
    if (widget.onSwipeEnd != null) {
      widget.onSwipeEnd!.call();
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _timer.reset();
    if (_recognized != 0) {
      if (widget.onSwipeEnd != null) {
        widget.onSwipeEnd!.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _onPointerDown(event);
      },
      onPointerMove: (event) {
        _onPointerMove(event);
      },
      onPointerUp: (event) {
        _onPointerUp(event);
      },
      onPointerCancel: (event) {
        _onPointerCancel(event);
      },
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}
