import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../zds_flutter.dart';

/// A [ZdsSlidableWidget] with pre-applied Zds styling. This widget is used specifically in [ZdsSlidableButton] to create a SlidableButton.
class ZdsSlidableWidget extends StatefulWidget {
  /// Displays button on the slidable button in [ZdsSlidableButton], responsible for detecting slide gestures and animating movement.
  const ZdsSlidableWidget({
    required this.child,
    required this.height,
    required this.handleWidth,
    required this.onSlide,
    this.onSlideValueCallback,
    this.onTapDown,
    this.onTapUp,
    super.key,
    this.isActive = true,
    this.animate = false,
    this.slidePercentageNeeded = 0.75,
    this.stayCompleted = false,
  });

  /// The `Widget` on which we want to detect the slide movement.
  final Widget child;

  /// The height of the widget that will be drawn, required.
  final double height;

  /// The width of the widget that will be drawn, required.
  final double handleWidth;

  /// The `VoidCallback` that will be called once a slide with certain percentage is detected.
  final VoidCallback onSlide;

  /// The `VoidCallback` that will be called once the toggle is tapped.
  final void Function()? onTapDown;

  /// The `VoidCallback` that will be called once the toggle tap is released.
  final void Function()? onTapUp;

  /// The `onSlideValue` as a callback provided to the parent [ZdsSlidableButton].
  final void Function(double value)? onSlideValueCallback;

  /// The decimal percentage of swiping in order for the callbacks to get called, defaults to 0.75 (75%) of the total width of the children.
  final double slidePercentageNeeded;

  /// Button is active value default : true.
  final bool isActive;

  /// Button animation after slide, this is defaulted to false for no animation.
  final bool animate;

  /// Keeps the toggle at one end after completion.
  final bool stayCompleted;

  @override
  ZdsSlidableWidgetState createState() => ZdsSlidableWidgetState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('height', height))
      ..add(DiagnosticsProperty<bool>('stayCompleted', stayCompleted))
      ..add(DoubleProperty('handleWidth', handleWidth))
      ..add(ObjectFlagProperty<VoidCallback>.has('onSlide', onSlide))
      ..add(ObjectFlagProperty<void Function()?>.has('onTapDown', onTapDown))
      ..add(ObjectFlagProperty<void Function()?>.has('onTapUp', onTapUp))
      ..add(ObjectFlagProperty<void Function(double value)?>.has('onSlideValueCallback', onSlideValueCallback))
      ..add(DoubleProperty('slidePercentageNeeded', slidePercentageNeeded))
      ..add(DiagnosticsProperty<bool>('isActive', isActive))
      ..add(DiagnosticsProperty<bool>('animate', animate));
  }
}

/// State is required for the animation and updating the position on [ZdsSlidableButton].
class ZdsSlidableWidgetState extends State<ZdsSlidableWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double _dxStartPosition = 0;
  double _dxEndsPosition = 0;

  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..addListener(() {
        setState(() {});
      });

    _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Resets the slideable widget.
  void reset() {
    _controller.animateTo(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
    _isComplete = false;
  }

  /// Completes the slider
  void complete() {
    final trackWidth = context.size!.width;

    _controller.animateTo(
      widget.handleWidth / trackWidth,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
    if (!widget.animate) {
      _controller.animateTo(
        trackWidth,
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _isComplete = widget.stayCompleted;

      widget.onSlide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// This onTap is included to show bounce slide suggestion to the user, this indicates the intended action of this button.
      onTap: () {
        if (widget.isActive && !_isComplete) {
          _controller.animateTo(0.6, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
          Future<void>.delayed(const Duration(milliseconds: 500), () {
            _controller.animateTo(1, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
          });
        }
      },
      onTapDown: (_) {
        if (widget.isActive && !_isComplete) {
          widget.onTapDown?.call();
        }
      },
      onTapUp: (_) => widget.onTapUp?.call(),
      onPanStart: (DragStartDetails details) {
        if (!_isComplete) {
          widget.onTapDown?.call();
          setState(() {
            _dxStartPosition = details.localPosition.dx - widget.handleWidth;
          });
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (widget.isActive && !_isComplete) {
          setState(() {
            _dxEndsPosition = details.localPosition.dx - widget.handleWidth;
          });

          final double trackWidth = context.size!.width;
          final double slideValue = widget.handleWidth / trackWidth;
          final double val = 1 - (((details.localPosition.dx) / trackWidth) - slideValue / 2);
          final bool isHandleAtEnd = val < slideValue;
          _controller.value = isHandleAtEnd ? slideValue : val;
          widget.onSlideValueCallback?.call(_controller.value - slideValue);
        }
      },
      onPanEnd: (DragEndDetails details) {
        widget.onTapUp?.call();
        if (widget.isActive && !_isComplete) {
          final double delta = _dxEndsPosition - _dxStartPosition;
          final double trackWidth = context.size!.width;
          double deltaNeededToBeSlided = trackWidth * widget.slidePercentageNeeded;
          deltaNeededToBeSlided -= 80.0;

          if (delta > deltaNeededToBeSlided) {
            complete();
          } else {
            _controller.animateTo(1, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
            widget.onSlideValueCallback?.call(1);
          }
        }
      },
      child: SizedBox(
        height: widget.height,
        child: Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: _controller.value,
            heightFactor: 1,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
