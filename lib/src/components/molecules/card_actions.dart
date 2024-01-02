import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// A widget used to show actions at the bottom of a [ZdsCard].
/// It's recommended to use [ZdsCardWithActions] instead of using this widget directly.
///
/// See also:
///
///  * [ZdsCardWithActions], which uses this widget to show actions at the bottom of the card.
class ZdsCardActions extends StatelessWidget {
  /// Constructs a [ZdsCardActions].
  const ZdsCardActions({
    super.key,
    this.children,
    this.alignment = MainAxisAlignment.end,
  });

  /// The widgets that will be laid out in a [Row].
  ///
  /// Typically [ZdsTag] and [ZdsLabel].
  final List<Widget>? children;

  /// If [children] only contains 1 widget, the alignment of said widget. Ignored if [children] contains more than 1
  /// widget, and MainAxisAlignment.spaceBetween will be used
  ///
  /// Defaults to [MainAxisAlignment.end].
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Zeta.of(context).colors.borderDisabled)),
      ),
      child: Row(
        mainAxisAlignment: alignment,
        children: children ?? <Widget>[],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<MainAxisAlignment>('alignment', alignment));
  }
}

/// The direction in which a [ZdsCardWithActions.children] will be laid out.
enum ZdsCardDirection {
  /// Sets cards in a horizontal row in [ZdsCardWithActions.children].
  horizontal,

  /// Sets cards in a vertical column in [ZdsCardWithActions.children].
  vertical,
}

/// Creates a [ZdsCard] with two sections, one for the main card content, and another one for status/actions
/// information.
///
/// This component can be used to display information that has a status (e.g., an equipment order with delivery status,
/// a task with completion information, an objective with a target date...).
///
/// The [children] will be laid out in a [Row] if [direction] is [ZdsCardDirection.horizontal], and in a [Column] if
/// [ZdsCardDirection.vertical]
///
/// ```dart
/// ZdsCardWithActions(
///   children: [
///     LeadingCardMainContent(),
///     TrailingCardMainContent()
///   ],
///   actions: [
///     ZdsTag(child: Text("Incomplete")),
///   ],
/// ),
/// ```
///
///
/// See also:
///
///  * [ZdsCard] for a card without the bottom actions/state row
///  * [ZdsCardHeader], used to create a title in cards.
///  * [ZdsCardActions], the widget used to lay out actions.
class ZdsCardWithActions extends StatelessWidget {
  /// Creates a card with a bottom section to display status/action information.
  const ZdsCardWithActions({
    super.key,
    this.actions,
    this.children,
    this.direction = ZdsCardDirection.horizontal,
    this.onTap,
  });

  /// Function called whenever the user taps anywhere on the card.
  final VoidCallback? onTap;

  /// The widgets shown as the card's main content, above the actions.
  final List<Widget>? children;

  /// Whether the [children] widgets will be laid out horizontally or vertically.
  final ZdsCardDirection direction;

  /// The widgets to show in the bottom part of the card. Typically contains [ZdsTag] and [ZdsLabel].
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final Widget content = direction == ZdsCardDirection.horizontal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children?.divide(const SizedBox(width: 16)).toList() ?? <Widget>[],
          )
        : Column(
            children: children?.divide(const SizedBox(height: 16)).toList() ?? <Widget>[],
          );
    return ZdsCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 20),
            child: content,
          ),
          if (actions != null && actions!.isNotEmpty) ZdsCardActions(children: actions),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(EnumProperty<ZdsCardDirection>('direction', direction));
  }
}
