import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

/// Component to add additional styling to a ZdsListTile.
///
/// Removes the gap between ZdsTiles when used in a list and adds dividing lines between the tiles and rounds the corners.
class ZdsListTileWrapper extends StatelessWidget {
  /// Typically a ZdsListTile for the styling to be applied to.
  final Widget child;

  /// Whether the tile is the first (at the top) of the list.
  ///
  /// Defaults to false.
  final bool top;

  /// Whether the tile is the last (at the bottom) of the list.
  ///
  /// Defaults to false.
  final bool bottom;

  /// Constructs a [ZdsListTileWrapper].
  const ZdsListTileWrapper({required this.child, super.key, this.top = false, this.bottom = false});

  @override
  Widget build(BuildContext context) {
    final ZetaColors colors = ZetaColors.of(context);
    return ClipRect(
      clipper: _PaddingRect(
        const EdgeInsets.symmetric(horizontal: 10).copyWith(top: top ? 10 : 0, bottom: bottom ? 10 : 0),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: top ? 10 : 0, bottom: bottom ? 10 : 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: top ? BorderSide.none : BorderSide(color: colors.cool.shade40),
              bottom: bottom ? BorderSide.none : BorderSide(color: colors.cool.shade40),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: colors.shadow,
              ),
            ],
          ),
          child: Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.only(
              topLeft: top ? const Radius.circular(6) : Radius.zero,
              topRight: top ? const Radius.circular(6) : Radius.zero,
              bottomLeft: bottom ? const Radius.circular(6) : Radius.zero,
              bottomRight: bottom ? const Radius.circular(6) : Radius.zero,
            ),
            color: ZetaColors.of(context).background,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: top ? BorderSide.none : BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('top', top))
      ..add(DiagnosticsProperty<bool>('bottom', bottom));
  }
}

class _PaddingRect extends CustomClipper<Rect> {
  _PaddingRect(this.padding);

  final EdgeInsets padding;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(padding.left * -1, 0, size.width + (padding.horizontal), size.height);
  }

  @override
  bool shouldReclip(_PaddingRect oldClipper) {
    return oldClipper.padding != padding;
  }
}
