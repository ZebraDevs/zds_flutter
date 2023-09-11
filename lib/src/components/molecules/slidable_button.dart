import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../../zds_flutter.dart';

// TODO(colors): Fix colors on track.

/// A SlidableButton with pre-applied Zds styling.
/// This grows to the width of its container.
class ZdsSlidableButton extends StatefulWidget {
  /// The future that is called when the button has been slid.
  /// While it is being awaited, a loading indicator will show.
  /// If the future returns true, the text and colors will be switched out for their 'end' equivalents
  /// If included the button is active, if not it will be disabled.
  final Future<bool> Function()? onSlideComplete;

  /// Called when the handle is tapped.
  final void Function()? onTapDown;

  /// Button background color.
  final Color? buttonSliderColor;

  /// Button color default.
  ///
  /// Defaults to `colors.primary`.
  final Color? buttonColor;

  /// Button center text.
  final String? buttonText;

  /// Button Icon when toggled.
  final IconData? buttonIcon;

  /// Button background color when toggled.
  final Color? buttonSliderColorEnd;

  /// Button color when toggled default.
  ///
  /// Defaults to `buttonColor.withOpacity(0.5)`, or if [buttonColor] is null, `colors.subtle`.
  final Color? buttonColorEnd;

  /// Button center text when toggled.
  final String? buttonTextEnd;

  /// Button Icon when toggled.
  final IconData? buttonIconEnd;

  /// Button animation after slide, this is defaulted to false for no animation.
  final bool animate;

  /// Circle indicator color.
  final Animation<Color?>? indicatorColor;

  /// Keeps the toggle at one end after completion.
  final bool stayCompleted;

  /// The duration to show the completed widget before the toggle resets.
  /// Will not do anything if [stayCompleted] is set to true.
  final Duration completedDisplayDuration;

  /// The message to be displayed when the button is disabled.
  /// Only shows if [onSlideComplete] is null.
  final String? disabledMessage;

  /// The height of the button.
  final double height;

  /// The width of the button handle.
  final double handleWidth;

  /// Base color used for button.
  final ZetaColorSwatch? colors;

  /// A button slider with a [ZdsSlidableWidget] as a child, the [ZdsSlidableWidget] is the slidable element.
  const ZdsSlidableButton({
    this.buttonText,
    this.buttonIcon,
    this.buttonSliderColor,
    this.buttonColor,
    this.onTapDown,
    this.onSlideComplete,
    this.animate = true,
    this.indicatorColor = const AlwaysStoppedAnimation<Color>(Colors.white),
    this.buttonSliderColorEnd,
    this.buttonColorEnd,
    this.buttonTextEnd,
    this.buttonIconEnd,
    this.stayCompleted = false,
    this.disabledMessage,
    this.completedDisplayDuration = const Duration(seconds: 2),
    this.handleWidth = 160,
    this.height = 64,
    this.colors,
    super.key,
  });

  @override
  ZdsSlidableButtonState createState() => ZdsSlidableButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Future<bool> Function()?>.has('onSlideComplete', onSlideComplete));
    properties.add(DiagnosticsProperty<Function?>('onTapDown', onTapDown));
    properties.add(ColorProperty('buttonSliderColor', buttonSliderColor));
    properties.add(ColorProperty('buttonColor', buttonColor));
    properties.add(StringProperty('buttonText', buttonText));
    properties.add(DiagnosticsProperty<IconData>('buttonIcon', buttonIcon));
    properties.add(ColorProperty('buttonSliderColorEnd', buttonSliderColorEnd));
    properties.add(ColorProperty('buttonColorEnd', buttonColorEnd));
    properties.add(StringProperty('buttonTextEnd', buttonTextEnd));
    properties.add(DiagnosticsProperty<IconData?>('buttonIconEnd', buttonIconEnd));
    properties.add(DiagnosticsProperty<bool>('animate', animate));
    properties.add(DiagnosticsProperty<Animation<Color?>?>('indicatorColor', indicatorColor));
    properties.add(DiagnosticsProperty<bool>('stayCompleted', stayCompleted));
    properties.add(DiagnosticsProperty<Duration>('completedDisplayDuration', completedDisplayDuration));
    properties.add(StringProperty('disabledMessage', disabledMessage));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('handleWidth', handleWidth));
    properties.add(ColorProperty('colors', colors));
  }
}

/// State for [ZdsSlidableButton].
class ZdsSlidableButtonState extends State<ZdsSlidableButton> {
  bool _isComplete = false;
  bool _isLoading = false;
  bool _isTapedDown = false;

  final GlobalKey _slideableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onSlideComplete() async {
    if (widget.onSlideComplete != null) {
      setState(() {
        _isLoading = true;
      });
      final isSuccessful = await widget.onSlideComplete!.call();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isTapedDown = false;
        });
      }
      if (isSuccessful) {
        setState(() {
          _isComplete = true;
        });
        if (!widget.stayCompleted) {
          await Future<void>.delayed(widget.completedDisplayDuration);
        }
      }
    }
    if (!widget.stayCompleted) reset();
  }

  /// Resets the slider.
  void reset() {
    if (_slideableKey.currentWidget is ZdsSlidableWidgetState) {
      (_slideableKey.currentState! as ZdsSlidableWidgetState).reset();
      setState(() {
        _isTapedDown = false;
        _isComplete = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ZetaColorSwatch colors = widget.colors ?? ZetaColors.of(context).primary;

    final Color buttonSliderColorEnd = widget.buttonSliderColorEnd ?? colors.shade20;
    final Color buttonSliderColor = widget.buttonSliderColorEnd ?? colors.shade20;
    final Color buttonColor = widget.buttonColor ?? colors.primary;
    final Color buttonColorComplete = widget.buttonColor?.withOpacity(0.5) ?? colors.subtle;

    final showDisabledMessage = widget.disabledMessage != null && widget.onSlideComplete == null;
    return Wrap(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          decoration: BoxDecoration(
            color: showDisabledMessage
                ? null
                : widget.buttonSliderColorEnd != null && _isComplete
                    ? buttonSliderColorEnd
                    : buttonSliderColor,
            borderRadius: BorderRadius.circular(widget.height),
          ),
          child: Stack(
            children: [
              ZdsSlidableWidget(
                key: _slideableKey,
                animate: widget.animate,
                isActive: widget.onSlideComplete != null && !_isLoading && !_isComplete,
                height: widget.height,
                onTapDown: () {
                  widget.onTapDown?.call();
                  setState(() {
                    _isTapedDown = true;
                  });
                },
                onTapUp: () {
                  setState(() {
                    _isTapedDown = false;
                  });
                },
                slidePercentageNeeded: 0.55,
                handleWidth: widget.handleWidth,
                stayCompleted: widget.stayCompleted,
                onSlide: _onSlideComplete,
                child: SizedBox(
                  height: widget.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.all(Radius.circular(widget.height)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: (_isLoading || _isTapedDown || _isComplete) &&
                                    widget.animate &&
                                    widget.buttonColorEnd != null
                                ? widget.buttonColorEnd
                                : widget.onSlideComplete != null
                                    ? buttonColor
                                    : buttonColorComplete,
                            borderRadius: BorderRadius.all(Radius.circular(widget.height)),
                          ),
                          height: widget.height,
                          width: widget.handleWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: widget.indicatorColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        _isComplete && widget.animate
                                            ? widget.buttonIconEnd ?? ZdsIcons.check_circle
                                            : widget.buttonIcon,
                                        color: widget.colors != null ? widget.colors?.on : ZdsColors.white,
                                        size: 20,
                                      ),
                              ),
                              Text(
                                ((_isComplete || _isTapedDown || _isLoading) && widget.buttonTextEnd != null
                                        ? widget.buttonTextEnd!
                                        : widget.buttonText) ??
                                    '',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: () {
                                        return widget.buttonColor != null
                                            ? computeForeground(widget.buttonColor!)
                                            : colors.on;
                                      }(),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showDisabledMessage)
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 320 - widget.handleWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.disabledMessage!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
