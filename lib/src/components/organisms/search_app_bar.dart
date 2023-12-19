import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../zds_flutter.dart';

/// An AppBar with an integrated [ZdsSearchField].
///
/// This is typically used to switch out [ZdsAppBar] to perform a search action. As both widgets implement
/// [PreferredSizeWidget], the Scaffold's appBar's height stays the same, and the body content is not displaced.
///
/// ```dart
/// Scaffold(
///   appBar: isSearching
///     ? ZdsSearchAppBar(
///       hintText: 'Search',
///       textEditingController: controller,
///       onSubmit: (text) {
///         controller.text = text;
///         state.searchTerm = text;
///         state.onSearchSubmit();
///       },
///       trailing: ZdsButton.text(
//          child: const Text('Cancel'),
//          onTap: () => (setState() => isSearching = false),
//        ),
///     )
///     : ZdsAppBar(
///       actions: [
///         IconButton(onPressed: () => (setState() => isSearching = true))
///       ],
///     )
/// )
/// ```
///
/// This component can be used to update search results in two ways. [onChange] and [onClear] can be used to update
/// the search results as the user types their query without needing to be submitted through the press of a button. If
/// the search requires a lookup that will take time, you can instead only use [onSubmit] to only query results when
/// the user presses the search button on their keyboard.
///
/// It is also possible to show an overlay on this appBar, which is typically used to inform the user about validation
/// errors or when no results are found.
///
/// ```dart
/// Scaffold(
///   appBar: ZdsSearchAppBar(
///     showOverlay: state.showNoResultsBar && state.searchString != '',
///     overlayBuilder: (_) => Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: [
///         Text('no results found...').padding(5),
///       ],
///     ).padding(10),
///     // Other code declaring the appBar's content goes here
///   ),
/// )
/// ```
///
/// See also:
///
///  * [ZdsSearchField], which this component uses to provide a search field.
///  * [ZdsAppBar], a more typical appBar
///  * [ZdsEmpty], which can be used to show a no results message.
class ZdsSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates an appBar with a search field.
  const ZdsSearchAppBar({
    super.key,
    this.hintText,
    this.onChange,
    this.onSubmit,
    this.leading,
    this.trailing,
    this.focusNode,
    this.textEditingController,
    this.height = 80.0,
    this.overlayBuilder,
    this.showOverlay = false,
    this.onClear,
    this.initValue,
    this.backgroundColor,
    this.topPadding,
  });

  /// Hint text that will appear when the user hasn't written anything in the search field.
  final String? hintText;

  /// Optional pre-filled text.
  ///
  /// If null, [hintText] will be shown instead.
  final String? initValue;

  /// Callback called whenever the search field's text changes.
  final void Function(String value)? onChange;

  /// Callback called whenever the user presses the 'Search' button on their keyboard.
  final void Function(String value)? onSubmit;

  /// Callback called whenever the text on the search field is cleared
  final VoidCallback? onClear;

  /// A controller that can be used to notify listeners when the text changes.
  final TextEditingController? textEditingController;

  /// A widget shown before the search field.
  ///
  /// Do not put actions like cancelling a search here, use [trailing] instead.
  final Widget? leading;

  /// A widget shown after the search field.
  ///
  /// Typically a [ZdsButton.text] used to show a 'cancel' button.
  final Widget? trailing;

  /// The focusNode for the search field.
  final FocusNode? focusNode;

  /// This appBar's preferred height.
  ///
  /// Defaults to 80.
  final double height;

  /// A builder for an optional overlay that will be shown below the search field.
  final WidgetBuilder? overlayBuilder;

  /// Whether to show the overlay created with [overlayBuilder].
  final bool showOverlay;

  /// Set custom background color .
  final Color? backgroundColor;

  /// Set custom top padding .
  final double? topPadding;

  @override
  ZdsSearchAppBarState createState() => ZdsSearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('hintText', hintText))
      ..add(StringProperty('initValue', initValue))
      ..add(ObjectFlagProperty<void Function(String value)?>.has('onChange', onChange))
      ..add(ObjectFlagProperty<void Function(String value)?>.has('onSubmit', onSubmit))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onClear', onClear))
      ..add(DiagnosticsProperty<TextEditingController?>('textEditingController', textEditingController))
      ..add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode))
      ..add(DoubleProperty('height', height))
      ..add(ObjectFlagProperty<WidgetBuilder?>.has('overlayBuilder', overlayBuilder))
      ..add(DiagnosticsProperty<bool>('showOverlay', showOverlay))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('topPadding', topPadding));
  }
}

/// State for [ZdsSearchAppBar].
class ZdsSearchAppBarState extends State<ZdsSearchAppBar> {
  final GlobalKey _searchKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  bool _isShowingOverlay() => _overlayEntry != null;

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _syncWidgetAndOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_isShowingOverlay() && !widget.showOverlay) {
        _hideOverlay();
      } else if (!_isShowingOverlay() && widget.showOverlay) {
        _showOverlay();
      }
    });
  }

  OverlayEntry? _createOverlayEntry() {
    if (widget.overlayBuilder == null) {
      return null;
    }

    final Offset offset = _searchKey.currentContext?.widgetGlobalPosition ?? Offset.zero;
    final Size size = _searchKey.currentContext?.widgetBounds.size ?? Size.zero;

    const EdgeInsets padding = EdgeInsets.all(20);

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: offset.dy + (size.height * 0.8),
        left: offset.dx + padding.left,
        width: size.width - padding.left - padding.right,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(6),
          child: widget.overlayBuilder?.call(context),
        ),
      ),
    );
  }

  bool _showSuffixClearButton = false;
  final TextEditingController _searchController = TextEditingController();

  TextEditingController get _textEditingController {
    return widget.textEditingController ?? _searchController;
  }

  @override
  void initState() {
    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
    }

    _textEditingController.addListener(_showClearButton);
    super.initState();
  }

  @override
  void didUpdateWidget(ZdsSearchAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncWidgetAndOverlay();
  }

  @override
  void reassemble() {
    super.reassemble();
    _syncWidgetAndOverlay();
  }

  @override
  void dispose() {
    if (_isShowingOverlay()) {
      _hideOverlay();
    }
    _textEditingController.removeListener(_showClearButton);
    super.dispose();
  }

  void _showClearButton() {
    setState(() {
      _showSuffixClearButton = _textEditingController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final IconButton? clearButton = _showSuffixClearButton
        ? IconButton(
            tooltip: ComponentStrings.of(context).get('CLEAR', 'Clear'),
            icon: Icon(
              ZdsIcons.close_circle,
              size: 20,
              color: Zeta.of(context).colors.iconSubtle,
            ),
            onPressed: () {
              _textEditingController.clear();
              widget.onChange?.call(_textEditingController.text);
              widget.onClear?.call();
            },
          )
        : null;

    final Color backgroundColor = widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: computeSystemOverlayStyle(backgroundColor),
      child: Material(
        color: backgroundColor,
        child: SafeArea(
          child: Row(
            children: <Widget>[
              if (widget.leading != null) widget.leading!,
              Expanded(
                child: ZdsSearchField(
                  key: _searchKey,
                  variant: ZdsSearchFieldVariant.outlined,
                  textFormFieldKey: _searchKey,
                  focusNode: widget.focusNode,
                  controller: _textEditingController,
                  hintText: widget.hintText,
                  onSubmit: widget.onSubmit,
                  onChange: widget.onChange,
                  initValue: widget.initValue,
                  suffixIcon: clearButton,
                  padding: EdgeInsets.zero.copyWith(
                    left: widget.leading == null ? 19 : 0,
                    right: widget.trailing == null ? 19 : 0,
                  ),
                ).paddingInsets(const EdgeInsets.symmetric(vertical: 4)),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
