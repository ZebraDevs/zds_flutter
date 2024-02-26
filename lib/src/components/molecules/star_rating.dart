import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

const double _starSize = 36;
const double _boxSize = 44;

/// Star rating component.
class ZdsStarRating extends StatefulWidget {
  /// Constructs a [ZdsStarRating].
  const ZdsStarRating({
    super.key,
    this.size = 5,
    this.initialValue = 0,
    this.halfIncrements = true,
    this.onChange,
    this.rounded = true,
    this.color,
  });

  /// Number of stars to show (full increments).
  ///
  /// Defaults to 5.
  final int size;

  /// Initial value of stars.
  final double initialValue;

  /// If true, half stars are allowed.
  ///
  /// Defaults to true.
  final bool halfIncrements;

  /// Called whenever the user changes the star value.
  final ValueChanged<double>? onChange;

  /// Sets rounded or sharp border of the containing box and the icon style.
  ///
  /// Defaults to `true`.
  final bool rounded;

  /// Optional color for the stars.
  ///
  /// Defaults to [ZetaColors.iconDefault].
  final Color? color;

  @override
  State<ZdsStarRating> createState() => _ZdsStarRatingState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<ValueChanged<double>>.has('onChange', onChange))
      ..add(DiagnosticsProperty<bool>('halfIncrements', halfIncrements))
      ..add(IntProperty('size', size))
      ..add(DoubleProperty('initialValue', initialValue))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(ColorProperty('color', color));
  }
}

class _ZdsStarRatingState extends State<ZdsStarRating> {
  double _value = 0;
  bool _selected = false;
  double? _valueTapped;

  void setValue(double value) {
    if (_value != value) {
      setState(() {
        _value = value;
        _valueTapped = value;
      });
      widget.onChange?.call(value);
    }
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(0, widget.size).toDouble();
  }

  double nearestValue(num input) {
    if (input < 0.25 || (!widget.halfIncrements && input < 0.5)) return 0;
    final wholeNumber = input.floor();
    final diff = input - wholeNumber;
    if (diff > 0.5 || !widget.halfIncrements) return wholeNumber.toDouble() + 1;
    return wholeNumber + 0.5;
  }

  void updateValue(double tapLocation, double maxWidth, BuildContext context) {
    final position = tapLocation;
    final selectedPercentage = position / maxWidth;
    final double newValue = nearestValue(selectedPercentage * widget.size).clamp(0, widget.size).toDouble();
    setValue(newValue);
  }

  _StarValue _starValue(int index) {
    if (index + 1 <= _value) return _StarValue.full;
    if (!_value.isWhole && index < _value) return _StarValue.half;
    return _StarValue.empty;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return SizedBox(
      width: _boxSize * widget.size.toDouble(),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return GestureDetector(
            onHorizontalDragStart: (details) => setState(() => _selected = true),
            onHorizontalDragEnd: (details) => setState(() => _selected = false),
            onHorizontalDragUpdate: (details) => updateValue(details.localPosition.dx, constraints.maxWidth, context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: colors.cool.shade30.withOpacity(_selected ? 1 : 0),
                borderRadius: widget.rounded ? ZetaRadius.rounded : ZetaRadius.none,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.size,
                  (int index) => SizedBox.square(
                    dimension: _boxSize,
                    child: InkWell(
                      borderRadius: widget.rounded ? ZetaRadius.rounded : ZetaRadius.none,
                      splashColor: colors.cool.shade30,
                      onTap: () {
                        if (widget.halfIncrements && index + 0.5 == _valueTapped) {
                          setValue(index.toDouble());
                        } else if (widget.halfIncrements && index + 1 == _valueTapped) {
                          setValue(index + 0.5);
                        } else if (index == 0 && !widget.halfIncrements) {
                          setValue(0);
                        } else {
                          setValue(index + 1);
                        }
                      },
                      child: Icon(
                        _starValue(index).icon(rounded: widget.rounded),
                        size: _starSize,
                        color: widget.color ?? colors.iconDefault,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _StarValue { empty, half, full }

extension on _StarValue {
  IconData icon({required bool rounded}) {
    switch (this) {
      case _StarValue.empty:
        return rounded ? ZetaIcons.star_outline_round : ZetaIcons.star_outline_sharp;
      case _StarValue.half:
        return rounded ? ZetaIcons.star_half_round : ZetaIcons.star_half_sharp;
      case _StarValue.full:
        return rounded ? ZetaIcons.star_round : ZetaIcons.star_sharp;
    }
  }
}
