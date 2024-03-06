import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The shake animation for the widgets.
///
/// Use this widget as a container in [StatefulWidget] where shake animation is needed.
/// This widget could be used where we need the users attention on some events.
///
/// ```dart
/// class ShakeExample extends StatefulWidget {
///   const ShakeExample({Key? key}) : super(key: key);
///
///   @override
///   State<ShakeExample> createState() => _ShakeExampleState();
/// }
///
/// class _ShakeExampleState extends State<ShakeExample> {
///   late final _shakeKey = GlobalKey<ZdsShakeAnimationState>();
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text('Shake Animation'),
///       ),
///       body: ZdsShakeAnimation(
///         key: _shakeKey,
///         shakeCount: 2,
///         shakeOffset: 5,
///         shakeDuration: const Duration(milliseconds: 350),
///         child: ZdsButton.filled(
///           child: const Text('Shake me!'),
///           onTap: () {
///             _shakeKey.currentState?.shake();
///           },
///         ),
///       ),
///     );
///   }
/// }
/// ```
class ZdsShakeAnimation extends StatefulWidget {
  /// Constructs a [ZdsShakeAnimation].
  const ZdsShakeAnimation({
    required this.child,
    required this.shakeOffset,
    super.key,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
    this.onAnimationUpdate,
  })  : assert(shakeOffset > 0, "'shakeOffset' should not be zero"),
        assert(shakeCount > 0, "'shakeCount' should not be zero");

  /// A child widget to animate.
  final Widget child;

  /// Horizontal shake offset
  /// ...<- [Widget] ->...
  final double shakeOffset;

  /// No of repetitions.
  final int shakeCount;

  /// Animation duration.
  final Duration shakeDuration;

  /// Animation status change call backs.
  final void Function(AnimationStatus)? onAnimationUpdate;

  @override
  ZdsShakeAnimationState createState() => ZdsShakeAnimationState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('shakeOffset', shakeOffset))
      ..add(IntProperty('shakeCount', shakeCount))
      ..add(DiagnosticsProperty<Duration>('shakeDuration', shakeDuration))
      ..add(ObjectFlagProperty<void Function(AnimationStatus p1)?>.has('onAnimationUpdate', onAnimationUpdate));
  }
}

/// State for [ZdsShakeAnimation], used to create a key:
///
/// ```dart
/// late final _shakeKey = GlobalKey<ZdsShakeAnimationState>();
/// ```
///
/// See also:
/// * [ZdsShakeAnimation].
class ZdsShakeAnimationState extends State<ZdsShakeAnimation> with SingleTickerProviderStateMixin {
  /// Animation Controller to control the shake.
  late final AnimationController animationController = AnimationController(vsync: this, duration: widget.shakeDuration);

  @override
  void dispose() {
    animationController
      ..removeStatusListener(_updateStatus)
      ..dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  void _updateStatus(AnimationStatus status) {
    widget.onAnimationUpdate?.call(status);

    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  /// Triggers the shaking animation.
  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: animationController,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double sineValue = sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(sineValue * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController>('animationController', animationController));
  }
}
