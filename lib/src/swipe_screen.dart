library swipe_screen;

/*
  Copyright 2022 Ka10008 All rights reserved.
  Released under the MIT License
  https://opensource.org/licenses/MIT
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'movement.dart';
import 'recognizer.dart';
import 'transition.dart';

enum SwipeDirection {
  fromLeft,
  fromTop,
  fromRight,
  fromBottom,
  none,
}

typedef SwipeCallback = void Function(SwipeDirection direction);

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({
    required Key key,
    required this.currentScreenBuilder,
    this.movement,
    this.swipeFromLeft,
    this.swipeFromTop,
    this.swipeFromRight,
    this.swipeFromBottom,
    this.onSwiped,
    this.isScrollEnable = false,
    this.initialScrollOffset = 0,
  }) : super(key: key);

  /// A builder for creating the current screen.
  /// Set Scaffold Widget, etc. in the return value to create a screen to be displayed
  /// before transitioning.
  ///
  /// If a scrollable widget such as a ListView is to be placed on the screen,
  /// the controller for that widget must be the [ScrollController] provided as an argument to this function.
  final Widget Function(ScrollController controller) currentScreenBuilder;

  /// Enables to start swiping the screen at arbitrary times.
  ///
  /// By assigning [SwipeMovement], the screen can be swiped at the timing
  /// when the [startTransition] method is executed.
  ///
  /// Assign the direction in which you want the screen to be swiped ([SwipeDirection])
  /// as the argument of the [startTransition] method.
  ///
  ///See [example] for detailed usage.
  final SwipeMovement? movement;

  /// Create a screen that transitions by swiping from left to right.
  ///
  /// To create a screen, it is necessary to define the widgets
  /// that make up the transition destination screen and the type of transition.
  ///
  /// See [SwipeTransition] for details.
  final SwipeTransition? swipeFromLeft;

  /// Create a screen that transitions by swiping from top to bottom.
  ///
  /// To create a screen, it is necessary to define the widgets
  /// that make up the transition destination screen and the type of transition.
  ///
  /// See [SwipeTransition] for details.
  final SwipeTransition? swipeFromTop;

  /// Create a screen that transitions by swiping from right to left.
  ///
  /// To create a screen, it is necessary to define the widgets
  /// that make up the transition destination screen and the type of transition.
  ///
  /// See [SwipeTransition] for details.
  final SwipeTransition? swipeFromRight;

  /// Create a screen that transitions by swiping from bottom to top.
  ///
  /// To create a screen, it is necessary to define the widgets
  /// that make up the transition destination screen and the type of transition.
  ///
  /// See [SwipeTransition] for details.
  final SwipeTransition? swipeFromBottom;

  /// A callback called when a swipe is made and screen movement is complete.
  /// The swiped direction can be acquired and arbitrary processing can be performed for each direction.
  ///
  /// [SwipeDirection.fromLeft] indicates a left-to-right swipe.
  /// [SwipeDirection.fromTop] indicates a top-to-bottom swipe.
  /// [SwipeDirection.fromRight] indicates a right-to-left swipe.
  /// [SwipeDirection.fromBottom] indicates a bottom-to-top swipe.
  /// [SwipeDirection.none] indicates that no swipe is performed.
  final SwipeCallback? onSwiped;

  /// If the current screen is scrollable, assign [true].
  final bool isScrollEnable;

  /// If the current screen is scrollable, the initial scroll offset can be set.
  /// This value is assigned to [initialScrollOffset] in [ScrollController].
  final double initialScrollOffset;

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  final _uniqueKey = UniqueKey();

  final VelocityTracker _tracker =
      VelocityTracker.withKind(PointerDeviceKind.touch);
  AnimationController? _animationController;
  late Animation<Offset> _currentScreenAnimation;
  late Animation<Offset> _overScreenAnimation;
  late ScrollController _scrollController;

  late SwipeMovement _movement;
  Widget? _transitionScreen;
  TransitionType? _transitionType;
  Widget? _overScreen;
  Widget? _underScreen;

  late bool _isSwipeHorizontal;
  late double _primaryExtent;
  late double _swipeExtent;
  late SwipeDirection _currentDirection;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _onAnimationCompleted();
        } else if (status == AnimationStatus.dismissed) {
          _onAnimationDismissed();
        }
      });
    _currentScreenAnimation = _getAnimation(Offset.zero, Offset.zero);
    _overScreenAnimation = _getAnimation(Offset.zero, Offset.zero);
    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollOffset,
    );
    _movement = widget.movement ?? SwipeMovement();
    if (_movement.direction != SwipeDirection.none) {
      _onMovementChange(_movement.direction);
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  SwipeDirection _getDirection(double extent) {
    if (extent == 0.0) {
      return SwipeDirection.none;
    } else if (extent > 0) {
      if (_isSwipeHorizontal) {
        _transitionScreen = widget.swipeFromLeft?.screen;
        _transitionType = widget.swipeFromLeft?.transitionType;
        return _transitionScreen == null
            ? SwipeDirection.none
            : SwipeDirection.fromLeft;
      } else {
        _transitionScreen = widget.swipeFromTop?.screen;
        _transitionType = widget.swipeFromTop?.transitionType;
        return _transitionScreen == null
            ? SwipeDirection.none
            : SwipeDirection.fromTop;
      }
    } else {
      if (_isSwipeHorizontal) {
        _transitionScreen = widget.swipeFromRight?.screen;
        _transitionType = widget.swipeFromRight?.transitionType;
        return _transitionScreen == null
            ? SwipeDirection.none
            : SwipeDirection.fromRight;
      } else {
        _transitionScreen = widget.swipeFromBottom?.screen;
        _transitionType = widget.swipeFromBottom?.transitionType;
        return _transitionScreen == null
            ? SwipeDirection.none
            : SwipeDirection.fromBottom;
      }
    }
  }

  List<Offset> _getOffset(SwipeDirection direction, double extent) {
    Offset currentBegin = Offset.zero;
    Offset overBegin = Offset.zero;
    Offset currentEnd = Offset.zero;
    Offset overEnd = Offset.zero;
    if (direction == SwipeDirection.none) {
      return [currentBegin, currentEnd];
    }
    if (_transitionType == TransitionType.push) {
      overBegin = _isSwipeHorizontal ? Offset(-extent, 0) : Offset(0, -extent);
    } else if (_transitionType == TransitionType.pop) {
      currentEnd = _isSwipeHorizontal ? Offset(extent, 0) : Offset(0, extent);
    }
    return [currentBegin, currentEnd, overBegin, overEnd];
  }

  Animation<Offset> _getAnimation(Offset begin, Offset end) {
    return _animationController!.drive(
      Tween<Offset>(
        begin: begin,
        end: end,
      ),
    );
  }

  void _setScreen(SwipeDirection direction) {
    if (direction == SwipeDirection.none) {
      return;
    }
    if (_transitionType == TransitionType.push) {
      _overScreen = _transitionScreen;
    } else if (_transitionType == TransitionType.pop) {
      _underScreen = _transitionScreen;
    }
  }

  void _onSwipeStart(PointerMoveEvent event) {
    _tracker.addPosition(event.timeStamp, event.position);
    _underScreen = null;
    _primaryExtent = 0;
    _swipeExtent = 0;
    _currentDirection = SwipeDirection.none;
    _animationController!.value = 0;
  }

  void _onSwipeUpdate(PointerMoveEvent event) {
    _tracker.addPosition(event.timeStamp, event.position);
    double currentExtent = _swipeExtent;
    final deltaX = event.localDelta.dx;
    final deltaY = event.localDelta.dy;
    if (widget.isScrollEnable) {
      if (!_isSwipeHorizontal && _scrollController.offset != 0.0) {
        return;
      }
    }
    if (_primaryExtent == 0) {
      _primaryExtent += _isSwipeHorizontal ? deltaX : deltaY;
    }
    currentExtent += _isSwipeHorizontal ? deltaX : deltaY;
    if (_primaryExtent.sign != currentExtent.sign) {
      return;
    }
    final oldDirection = _currentDirection;
    _currentDirection = _getDirection(currentExtent);
    if (_currentDirection == SwipeDirection.none) {
      return;
    }
    _swipeExtent = currentExtent;
    if (oldDirection != _currentDirection) {
      final offset = _getOffset(_currentDirection, _swipeExtent.sign);
      setState(() {
        _setScreen(_currentDirection);
        _currentScreenAnimation = _getAnimation(offset[0], offset[1]);
        _overScreenAnimation = _getAnimation(offset[2], offset[3]);
      });
    }
    if (!_animationController!.isAnimating) {
      final size =
          _isSwipeHorizontal ? context.size!.width : context.size!.height;
      _animationController!.value = _swipeExtent.abs() / size;
      if (widget.isScrollEnable) {
        _isSwipeHorizontal
            ? _scrollController.jumpTo(_scrollController.offset)
            : _scrollController.jumpTo(0.0);
      }
    }
  }

  void _onSwipeEnd() {
    final flingVelocity = _isSwipeHorizontal
        ? _tracker.getVelocity().pixelsPerSecond.dx
        : _tracker.getVelocity().pixelsPerSecond.dy;
    final flingDirection = _getDirection(flingVelocity);
    if (_currentDirection == SwipeDirection.none) {
      return;
    }
    if (flingDirection == _currentDirection) {
      _animationController!.forward();
    } else {
      _animationController!.reverse();
    }
  }

  void _onMovementChange(SwipeDirection direction) async {
    double extent = 0;
    _currentDirection = direction;
    switch (direction) {
      case SwipeDirection.fromLeft:
        _isSwipeHorizontal = true;
        _transitionScreen = widget.swipeFromLeft?.screen;
        _transitionType = widget.swipeFromLeft?.transitionType;
        extent = 1.0;
        break;
      case SwipeDirection.fromTop:
        _isSwipeHorizontal = false;
        _transitionScreen = widget.swipeFromTop?.screen;
        _transitionType = widget.swipeFromTop?.transitionType;
        extent = 1.0;
        break;
      case SwipeDirection.fromRight:
        _isSwipeHorizontal = true;
        _transitionScreen = widget.swipeFromRight?.screen;
        _transitionType = widget.swipeFromRight?.transitionType;
        extent = -1.0;
        break;
      case SwipeDirection.fromBottom:
        _isSwipeHorizontal = false;
        _transitionScreen = widget.swipeFromBottom?.screen;
        _transitionType = widget.swipeFromBottom?.transitionType;
        extent = -1.0;
        break;
      case SwipeDirection.none:
        break;
    }
    if (_transitionScreen == null || _transitionType == null) {
      return;
    }
    final offset = _getOffset(_currentDirection, extent);
    setState(() {
      _setScreen(_currentDirection);
      _currentScreenAnimation = _getAnimation(offset[0], offset[1]);
      _overScreenAnimation = _getAnimation(offset[2], offset[3]);
    });
    await _animationController!.forward();
  }

  void _onAnimationDismissed() {
    setState(() {
      _overScreen = null;
      _currentScreenAnimation = _getAnimation(Offset.zero, Offset.zero);
      _overScreenAnimation = _getAnimation(Offset.zero, Offset.zero);
    });
  }

  void _onAnimationCompleted() {
    if (widget.onSwiped != null) {
      widget.onSwiped!.call(_currentDirection);
    }
    setState(() {
      _overScreen = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget stack = Stack(
      children: [
        if (_underScreen != null)
          Positioned.fill(
            child: ClipRect(
              clipper: _SwipeScreenClipper(
                isSwipeHorizontal: _isSwipeHorizontal,
                animation: _currentScreenAnimation,
              ),
              child: _underScreen!,
            ),
          ),
        SlideTransition(
          key: _uniqueKey,
          position: _currentScreenAnimation,
          child: Material(
            elevation: 15,
            shadowColor: Colors.white70,
            child: widget.currentScreenBuilder(_scrollController),
          ),
        ),
        if (_overScreen != null)
          SlideTransition(
            position: _overScreenAnimation,
            child: Material(
              elevation: 15,
              shadowColor: Colors.white70,
              child: _overScreen!,
            ),
          ),
      ],
    );

    return SwipeRecognizer(
      onSwipeStart: (event, isHorizontal) {
        _isSwipeHorizontal = isHorizontal;
        _onSwipeStart(event);
      },
      onSwipeUpdate: (event) {
        _onSwipeUpdate(event);
      },
      onSwipeEnd: () {
        _onSwipeEnd();
      },
      child: stack,
    );
  }
}

class _SwipeScreenClipper extends CustomClipper<Rect> {
  _SwipeScreenClipper({
    this.isSwipeHorizontal = true,
    required this.animation,
  }) : super(reclip: animation);

  final bool isSwipeHorizontal;
  final Animation<Offset> animation;

  @override
  Rect getClip(Size size) {
    if (isSwipeHorizontal) {
      final double offset = animation.value.dx * size.width;
      return offset > 0
          ? Rect.fromLTRB(0.0, 0.0, offset, size.height)
          : Rect.fromLTRB(size.width + offset, 0.0, size.width, size.height);
    } else {
      final double offset = animation.value.dy * size.height;
      return offset > 0
          ? Rect.fromLTRB(0.0, 0.0, size.width, offset)
          : Rect.fromLTRB(0.0, size.height + offset, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(_SwipeScreenClipper oldClipper) {
    return oldClipper.animation.value != animation.value;
  }
}
