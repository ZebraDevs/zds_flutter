// This ignore is applied due to the use of deprecated members within the same
// package. The deprecated members are still in use as they are part of a
// legacy implementation that has not yet been fully refactored or replaced.
// While it is generally recommended to avoid deprecated members, this
// decision is made to ensure backward compatibility and avoid breaking
// changes in the current version. The refactor to remove deprecated members
// will be planned for the next major release.
// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../tools.dart';

/// This widget can be used for nested flows where some parent widget has to be made available to all of
/// its descendants. For example, a provider that needs to be made available to all routes below it.
///
/// ```dart
/// SomeProvider(
///   child: ZdsNestedFlow(
///     rootPage: MaterialPage(child: SomeWidgetPage()),
///     onGenerateRoute: _generateRoute,
///   ),
/// )
/// ```
class ZdsNestedFlow extends StatefulWidget {
  /// Constructs a [ZdsNestedFlow].
  const ZdsNestedFlow({
    super.key,
    this.onGenerateRoute,
    this.child,
    this.builder,
  }) : assert(
          (child != null ? 1 : 0) + (builder != null ? 1 : 0) == 1,
          'Exactly one of child, or builder must be provided',
        );

  /// Child widget for the navigator root page.
  final Widget? child;

  /// WidgetBuilder for the navigator root page.
  final WidgetBuilder? builder;

  /// Route factory for page based navigator 1.0.
  final RouteFactory? onGenerateRoute;

  @override
  ZdsNestedFlowState createState() => ZdsNestedFlowState();

  /// Return the [ZdsNestedFlowState] of the current [ZdsNestedFlow]
  static ZdsNestedFlowState of(BuildContext context) {
    final ZdsNestedFlowState? stateOfType = context.findAncestorStateOfType<ZdsNestedFlowState>();
    if (stateOfType == null) {
      throw FlutterError('Ancestor state of type ZdsNestedFlowState not found');
    }
    return stateOfType;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Widget>('child', child))
      ..add(ObjectFlagProperty<WidgetBuilder?>.has('builder', builder))
      ..add(ObjectFlagProperty<RouteFactory?>.has('onGenerateRoute', onGenerateRoute));
  }
}

/// State for [ZdsNestedFlowState].
class ZdsNestedFlowState extends State<ZdsNestedFlow> implements NavigatorObserver {
  late final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  int _nestedRoutes = 0;

  /// Dismisses the nested navigation flow
  void pop<T extends Object?>([T? result]) {
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_navigator.currentState?.canPop() ?? false) {
          await _navigator.currentState?.maybePop(result);
        } else {
          Navigator.of(context).pop(result);
        }
      },
      child: Navigator(
        key: _navigator,
        observers: [this],
        initialRoute: '/',
        onGenerateRoute: widget.onGenerateRoute,
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            if (widget.builder != null)
              ZdsFadePageRouteBuilder(
                builder: (BuildContext context) {
                  return PopScope(
                    canPop: false,
                    child: widget.builder!(context),
                  );
                },
              )
            else if (widget.child != null)
              ZdsFadePageRouteBuilder(
                builder: (BuildContext context) {
                  return PopScope(
                    canPop: false,
                    child: widget.child!,
                  );
                },
              )
            else
              throw FlutterError('Exactly one of child, builder, or rootPage must be provided'),
          ];
        },
      ),
    );
  }

  @override
  NavigatorState? get navigator => null;

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}

  @override
  void didStartUserGesture(_, __) {}

  @override
  void didStopUserGesture() {}

  @override
  void didPush(_, __) {
    _nestedRoutes++;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _nestedRoutes--;
    unawaited(_checkPop(route));
  }

  @override
  void didRemove(Route<dynamic> route, __) {
    _nestedRoutes--;
    unawaited(_checkPop(route));
  }

  Future<void> _checkPop(Route<dynamic> route) async {
    if (_nestedRoutes == 0) {
      Navigator.of(context).pop(await route.popped);
    }
  }

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    // TODO: implement didChangeTop
  }
}
