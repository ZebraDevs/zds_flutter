import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../zds_flutter.dart';

/// Button type for [CircleIconButton]
enum CircleButtonType {
  /// Positive button, defaults to green
  positive,

  /// Negative button, defaults to red
  negative,

  ///Alert button, defaults to white
  alert,

  /// Untoggled button, defaults to white
  base,

  /// Toggled button, defaults to black
  toggled
}

/// Button size for [CircleIconButton]
enum ButtonSize {
  /// Large
  large,

  /// Medium
  medium,

  /// Small
  small
}

extension on CircleButtonType {
  ZetaColorSwatch color(ZetaColors colors) {
    switch (this) {
      case CircleButtonType.positive:
        return colors.positive;
      case CircleButtonType.negative:
        return colors.negative;
      case CircleButtonType.alert:
        return ZetaColorSwatch.fromColor(Colors.white);
      case CircleButtonType.base:
        return ZetaColorSwatch.fromColor(Colors.grey.shade100);
      case CircleButtonType.toggled:
        return ZetaColorSwatch.fromColor(Colors.black);
    }
  }

  ZetaColorSwatch borderColor(ZetaColors colors) {
    switch (this) {
      case CircleButtonType.alert:
        return ZetaColorSwatch.fromColor(Colors.red);
      case CircleButtonType.base:
        return ZetaColorSwatch.fromColor(colors.borderSubtle);
      case CircleButtonType.toggled:
        return ZetaColorSwatch.fromColor(colors.borderSubtle);
      case CircleButtonType.positive:
      case CircleButtonType.negative:
        return ZetaColorSwatch.fromColor(Colors.white);
    }
  }

  ZetaColorSwatch foregroundColor(ZetaColors colors) {
    switch (this) {
      case CircleButtonType.alert:
        return ZetaColorSwatch.fromColor(Colors.red);
      case CircleButtonType.base:
        return ZetaColorSwatch.fromColor(Colors.black);
      case CircleButtonType.toggled:
      case CircleButtonType.positive:
      case CircleButtonType.negative:
        return ZetaColorSwatch.fromColor(Colors.white);
    }
  }

  bool get border => index > 1;
}

/// Component [CircleIconButton]
class CircleIconButton extends StatefulWidget {
  /// Constructor for [CircleIconButton]

  const CircleIconButton({
    super.key,
    this.size = ButtonSize.large,
    required this.type,
    required this.icon,
    required this.label,
    this.activeIcon,
    this.activeLabel,
    required this.onTap,
  });

  /// Size for [CircleIconButton]
  final ButtonSize size;

  /// Type of [CircleIconButton]
  final CircleButtonType type;

  /// Default icon
  final IconData icon;

  /// Default label
  final String label;

  /// Toggled icon
  final IconData? activeIcon;

  /// Toggled label
  final String? activeLabel;

  /// Callback function
  final VoidCallback onTap;

  @override
  State<CircleIconButton> createState() => _CircleIconButton();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ButtonSize>('size', size))
      ..add(EnumProperty<CircleButtonType>('type', type))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<IconData?>('activeIcon', activeIcon))
      ..add(StringProperty('activeLabel', activeLabel))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _CircleIconButton extends State<CircleIconButton> {
  CircleButtonType type = CircleButtonType.positive;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  Future<void> handleClick() async {
    final bool isToggleable = type == CircleButtonType.toggled || type == CircleButtonType.base;

    //Change style to show button clicking effect
    if (!isToggleable) {
      setState(() {
        isPressed = true;
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (isToggleable) {
      setState(() {
        type = (type == CircleButtonType.toggled) ? CircleButtonType.base : CircleButtonType.toggled;
      });
    }

    setState(() {
      isPressed = false;
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    final bool toggled = type == CircleButtonType.toggled;

    return Column(
      children: [
        GestureDetector(
          onTap: handleClick,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: _animatedStyle(colors, isPressed),
            child: Icon(
              toggled ? widget.activeIcon : widget.icon,
              size: _iconSize,
              color: type.foregroundColor(colors),
            ).padding(_iconPadding),
          ),
        ),
        Text(
          toggled ? widget.activeLabel! : widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: widget.size == ButtonSize.small ? 14 : 16,
          ),
        ),
      ]
          .divide(
            const SizedBox(
              height: ZetaSpacing.xxs,
            ),
          )
          .toList(),
    );
  }

  double get _iconPadding {
    switch (widget.size) {
      case ButtonSize.large:
        return ZetaSpacing.x5;
      case ButtonSize.medium:
        return 15;
      case ButtonSize.small:
        return ZetaSpacing.x1;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.large:
        return ZetaSpacing.x10;
      case ButtonSize.medium:
        return ZetaSpacing.x7_5;
      case ButtonSize.small:
        return ZetaSpacing.x5;
    }
  }

  BoxDecoration _animatedStyle(ZetaColors colors, bool isPressed) {
    return BoxDecoration(
      color: isPressed ? type.color(colors).shade70 : type.color(colors),
      borderRadius: const BorderRadius.all(Radius.circular(360)),
      border: type.border
          ? Border.all(
              color: type.borderColor(colors),
            )
          : null,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<CircleButtonType>('type', type))
      ..add(DiagnosticsProperty<bool>('isPressed', isPressed));
  }
}
