import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';
import '../../utils/tools/measure.dart';

const Duration _kFadeDuration = Duration(milliseconds: 200);

/// A component that can be collapsed and uncollapsed.
///
/// This is typically used with long [Text] widgets, where their length might complicate navigation.
///
/// When collapsed, the component will take the height of [minHeight]. If the [child]'s height does not exceed
/// [minHeight], then no button to collapse/expand the widget will be shown.
///
/// See also:
///
///  * [ExpandableTextExtension.readMore], an alternative way of making a collapsible widget.
class ZdsExpandable extends StatelessWidget {
  /// A widget that can be collapsed and expanded.
  const ZdsExpandable({
    required this.child,
    super.key,
    this.collapsedButtonText = '',
    this.expandedButtonText = '',
    this.minHeight = 60,
    this.color,
  });

  /// The text to show in the button when the [child] is collapsed.
  final String collapsedButtonText;

  /// The text to show in the button when the [child] is expanded.
  final String expandedButtonText;

  /// The [child]'s height when it's in its collapsed state.
  ///
  /// Defaults to 60.
  final double minHeight;

  /// The child that will be collapsed and extended.
  ///
  /// Typically a [Text].
  final Widget child;

  /// The color to be used for the fadeout gradient indicating the widget is collapsed.
  ///
  /// Defaults to [ColorScheme.background].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return child.readMore(
      collapsedButtonText: collapsedButtonText,
      expandedButtonText: expandedButtonText,
      color: color ?? Theme.of(context).colorScheme.background,
      minHeight: minHeight,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('collapsedButtonText', collapsedButtonText))
      ..add(StringProperty('expandedButtonText', expandedButtonText))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(ColorProperty('color', color));
  }
}

class _ExpandableContainer extends StatefulWidget {
  const _ExpandableContainer({
    required this.collapsedButtonText,
    required this.expandedButtonText,
    required this.minHeight,
    required this.child,
    required this.color,
  });
  final String collapsedButtonText;
  final String expandedButtonText;
  final double minHeight;
  final Widget child;
  final Color color;

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('collapsedButtonText', collapsedButtonText))
      ..add(StringProperty('expandedButtonText', expandedButtonText))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(ColorProperty('color', color));
  }
}

class _ExpandableContainerState extends State<_ExpandableContainer> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  double _textHeight = 0;
  Animation<double>? _sizeAnimation;
  late AnimationController _controller;
  final GlobalKey<State<StatefulWidget>> _keyText = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _kFadeDuration);
    _controller.addListener(onControllerValue);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _afterLayout(_) {
    final RenderBox renderBox = _keyText.currentContext!.findRenderObject()! as RenderBox;
    _textHeight = renderBox.size.height;
    _sizeAnimation = Tween<double>(begin: widget.minHeight, end: _textHeight).animate(_controller);
  }

  void onControllerValue() {
    setState(() {});
  }

  double get textHeight => _sizeAnimation?.value ?? widget.minHeight;

  @override
  Widget build(BuildContext context) {
    return _ExpandableClip(
      color: widget.color,
      isExpanded: isExpanded,
      contentKey: _keyText,
      button: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve(<MaterialState>{}),
          backgroundColor: Colors.transparent,
        ),
        onPressed: isExpanded ? collapse : expand,
        child: AnimatedCrossFade(
          duration: _kFadeDuration,
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Text(widget.collapsedButtonText),
          secondChild: Text(widget.expandedButtonText),
        ),
      ).frame(alignment: Alignment.center),
      height: textHeight,
      child: widget.child,
    );
  }

  void collapse() {
    setState(() {
      isExpanded = false;
    });
    _controller.reverse();
  }

  void expand() {
    setState(() {
      isExpanded = true;
    });
    _controller.forward();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isExpanded', isExpanded))
      ..add(DoubleProperty('textHeight', textHeight));
  }
}

class _ExpandableClip extends StatelessWidget {
  const _ExpandableClip({
    required this.height,
    required this.button,
    required this.color,
    required this.child,
    this.contentKey,
    this.isExpanded = false,
  });
  final Widget child;
  final Widget button;
  final double height;
  final bool isExpanded;
  final Color color;
  final Key? contentKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRect(
          child: SizedOverflowBox(
            // this is so that I can measure the real height
            alignment: Alignment.topCenter,
            size: Size(double.infinity, height),
            child: Container(
              key: contentKey,
              child: child,
            ),
          ),
        ),
        // overflow
        SizedBox(
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: -55,
                height: 55,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: _kFadeDuration,
                  opacity: isExpanded ? 0 : 1,
                  child: _FadeOpacity(color: color),
                ),
              ),
              button,
            ],
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('height', height))
      ..add(DiagnosticsProperty<bool>('isExpanded', isExpanded))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty<Key?>('contentKey', contentKey));
  }
}

class _FadeOpacity extends StatelessWidget {
  const _FadeOpacity({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const <double>[0, 1],
          colors: <Color>[
            color,
            color.withOpacity(0),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}

/// A widget extension that enables the widget to be collapsed and uncollapsed.
extension ExpandableTextExtension on Widget {
  /// A widget extension that enables the widget to be collapsed and uncollapsed.
  ///
  /// ```dart
  /// Text(
  ///   'Some very long text that will need to be collapsed.',
  ///   textAlign: TextAlign.justify,
  /// ).readMore(collapsedButtonText: 'Read More', expandedButtonText: 'Collapse',)
  /// ```
  ///
  /// This is typically used with long [Text] widgets, where their length might complicate navigation.
  ///
  /// When collapsed, the component will take the height of [minHeight]. If the icon's height does not exceed
  /// [minHeight], then no button to collapse/expand the widget will be shown.
  ///
  /// [collapsedButtonText] and [expandedButtonText] define the button's text for when the widget is collapsed and
  /// expanded respectively. [color] defines the color to be used for the fadeout gradient indicating the widget is
  /// collapsed, and defaults to [ColorScheme.background].
  ///
  /// See also:
  ///
  ///  * [ZdsExpandable], which wraps the widget to collapse/expand instead.
  Widget readMore({
    String collapsedButtonText = '',
    String expandedButtonText = '',
    double minHeight = 60,
    Color? color,
  }) {
    return MeasureSize(
      child: this,
      builder: (BuildContext context, Size size) {
        final ComponentStrings strings = ComponentStrings.of(context);
        if (size.height < minHeight) {
          return Padding(padding: const EdgeInsets.only(bottom: 16), child: this);
        }
        return _ExpandableContainer(
          collapsedButtonText:
              collapsedButtonText.isEmpty ? strings.get('READ_MORE', 'Read more') : collapsedButtonText,
          expandedButtonText: expandedButtonText.isEmpty ? strings.get('COLLAPSE', 'Collapse') : expandedButtonText,
          minHeight: minHeight,
          color: color ?? Theme.of(context).colorScheme.background,
          child: this,
        );
      },
    );
  }
}
