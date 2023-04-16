A Flutter package that enables screen transitions by swiping.

![all-direction](https://user-images.githubusercontent.com/96510219/208082082-9c26405b-94ca-45b6-bc8a-337852a01617.gif)

## Features

- Screen transitions can be assigned to swipe operations in each of the four directions.
  - swipeFromLeft: Left to Right
  - swipeFromTop: Top to Bottom
  - swipeFromRight: Right to Left
  - swipeFromBottom: Bottom to Top.
- Enables to start swiping the screen at arbitrary times.
  - When `movement` is set, the screen swiping starts at the timing when `startTransition()` is executed.
  - The direction in which the screen is swiped can set by the argument of `startTransition()`.
- The type of screen transition can be selected.
  - Overlay the destination screen on top of the current screen (`TransitionType.push`)
  - Display the destination screen from the below of the current screen (`TransitionType.pop`)
- Can coexist with scrollable widgets.
  - The `controller` of the scrollable widget must be assigned the `ScrollController` provided by `currentScreenBuilder`.
- The process to be performed when the screen transition by swiping is completed can be specified.
  - With 'onSwiped', the direction of the swipe can get.
  - Different processes can be implemented for each swipe direction.

## Getting started

Add the latest version of `swipe_screen` to `pubspec.yaml` as a dependency.

```yaml
dependencies:
  swipe_screen: ^[latest version]
```

## Usage

- [Parameters](#parameters)
  - [SwipeScreen](#swipescreen)
  - [SwipeTransition](#swipetransition)
- [Example](#example)

### Parameters

- Both `SwipeScreen` and `SwipeTransition` are needed to enable screen transitions by swiping.
- The parameters of each class are shown below.

#### SwipeScreen

| Parameter | Class | Description |
|-|-|-|
| `currentScreenBuilder` | Function | A builder for creating the current screen. If a scrollable widget is to be placed on the screen, the controller for that widget must be the `ScrollController` provided by this function. |
| `movement` | SwipeMovemnt | Enables to start swiping the screen at arbitrary times. |
| `swipeFromLeft` | SwipeTransition | Create a screen that transitions by swiping from left to right. |
| `swipeFromTop` | SwipeTransition | Create a screen that transitions by swiping from top to bottom. |
| `swipeFromRight` | SwipeTransition | Create a screen that transitions by swiping from right to left. |
| `swipeFromBottom` | SwipeTransition | Create a screen that transitions by swiping from bottom to top. |
| `onSwiped` | SwipeCallBack | A callback called when a swipe is made and screen transition is complete. The direction of the swipe can get. |
| `isScrollEnable` | bool | If a scrollable widget is to be placed on the `currentScreenBuilder`, assign `true`. |
| `initialScrollOffset` | double | If the current screen is scrollable, the initial scroll offset can be set. |

#### SwipeTransition

| Parameter | Class | Description |
|-|-|-|
| `screen` | Widget | A widget that creates a screen that transitions with a swipe. |
| `transitionType` | TransitionType | A type of transition by swiping the screen. |

- There are two types of `TransitionType` as follows.
  - `TransitionType.push`   
    The transition is made so that the destination screen overlaps the current screen.
  - `TransitionType.pop`   
    The screen to be transitioned to is displayed from below of the current screen.

### Example

#### Code

##### HomeScreen

```dart
final SwipeMovement _movement = SwipeMovement();

SwipeScreen(
  key: UniqueKey(),
  movement: _movement,
  swipeFromLeft: SwipeTransition(
    screen: LeftScreen(),
    transitionType: TransitionType.push,
  ),
  currentScreenBuilder: (ScrollController controller) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HomeScreen',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _movement.startTransition(SwipeDirection.fromLeft);
                });
              },
              child: const Text(
                'to LeftScreen',
              ),
            ),
          ],
        ),
      ),
    );
  },
  onSwiped: (direction) {
    if (direction == SwipeDirection.fromLeft) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LeftScreen(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  },
);
```

##### LeftScreen

```dart
final SwipeMovement _movement = SwipeMovement();
WillPopScope(

  child: SwipeScreen(
    key: UniqueKey(),
    movement: _movement,
    swipeFromRight: SwipeTransition(
      screen: HomeScreen(),
      transitionType: TransitionType.pop,
    ),
    currentScreenBuilder: (ScrollController controller) {
      return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.red.shade100,
          body: const Center(
            child: Text(
              'LeftScreen',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
        ),
        onWillPop: () async {
          setState(() {
            _movement.startTransition(SwipeDirection.fromRight);
          });
          return false;
        },
      );
    },
    onSwiped: (direction) {
      if (direction == SwipeDirection.fromRight) {
        Navigator.of(context).pop();
      }
    },
  ),
);
```

#### Motion

![home-to-left](https://user-images.githubusercontent.com/96510219/231736042-87472f8b-095a-4215-87ee-165d0cfabf5a.gif)