import 'dart:math' show min;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// A [ZdsSplitNavigator] used to navigate the screen for the split view for tablet.
///
/// By default the primary widget will be visible in the tablet portrait mode and in the tablet landscape mode screen will be
/// split into two part and secondary widget will be displayed on the right side of of the the screen.
/// The push operation will push the page only on the right side of the part.
///

class ZdsSplitNavigator extends StatefulWidget {
  /// Creates a split navigator.
  const ZdsSplitNavigator({
    required this.primaryWidget,
    required this.emptyBuilder,
    required this.shouldSplit,
    this.widthRatio = 0.4,
    this.onGenerateRoute,
    this.maxPrimaryWidth,
    this.splitNavigatorKey,
    this.boxShadowDivider = true,
    this.alwaysSplit = false,
    super.key,
  });

  /// String used for empty detail routes.
  static const String emptyRoute = 'Zds-empty-route';

  /// Flag used to decide whether split navigator should be used or not.
  ///
  /// Typical use ```shouldSplit: kIsWeb || context.isTablet()```
  ///
  /// Making this mandatory so that existing implementations do not miss this change.
  ///
  /// If the value is set to true, then a nested navigator will be injected otherwise, the nearest navigator will be used.
  final bool shouldSplit;

  /// Widget that will be shown at the left side in the landscape mode. and full screen in the portrait mode. Typically [Scaffold].
  final Widget primaryWidget;

  /// Called to generate a route for a given [RouteSettings].
  final RouteFactory? onGenerateRoute;

  /// Initial page that will be visible on the right side in the landscape mode. Typically [Scaffold].
  final WidgetBuilder emptyBuilder;

  /// Primary to secondary width ratio
  ///
  /// Default is 0.4
  /// Meaning, primary widget will have 40% of available space and secondary will get 60%.
  /// If the [maxPrimaryWidth] parameter is not null, then the minimum of the width after calculating the ratio
  /// and maxPrimaryWidth will be used to set the widgets' width in split mode.
  final double widthRatio;

  /// Whether to divide the views using a shadow, rather than a line.
  ///
  /// Defaults to true.
  final bool boxShadowDivider;

  /// To split the screen respective of orientation
  /// Note: In QChat we are showing split view in portrait also
  /// Defaults to false.
  final bool alwaysSplit;

  /// Max width for primary widget when it's being displayed in split mode.
  ///
  /// Default is null, and widthRatio will have control on width.
  final double? maxPrimaryWidth;

  /// Navigator key used in split mode.
  ///
  /// This key will be used on only in split mode.
  final GlobalKey<NavigatorState>? splitNavigatorKey;

  /// Retrieves the nearest [ZdsSplitNavigatorState] ancestor from the given [BuildContext].
  ///
  /// This method searches up the widget tree starting from the given [BuildContext],
  /// and returns the nearest ancestor of type [ZdsSplitNavigatorState].
  ///
  /// If no [ZdsSplitNavigatorState] ancestor is found, a [FlutterError] is thrown.
  ///
  /// Usage:
  /// ```
  /// final ZdsSplitNavigatorState = ZdsSplitNavigatorState.of(context);
  /// ```
  ///
  /// [context]: The [BuildContext] to start the search from.
  ///
  /// Returns: The nearest [ZdsSplitNavigatorState] ancestor found.
  static ZdsSplitNavigatorState of(BuildContext context) {
    final ZdsSplitNavigatorState? state = context.findAncestorStateOfType<ZdsSplitNavigatorState>();
    if (state == null) throw FlutterError('Ancestor state of type ZdsSplitNavigatorState not found');
    return state;
  }

  /// Returns the ZdsSplitNavigatorState if it exists, or null if it throws an exception.
  static ZdsSplitNavigatorState? _safeState(BuildContext context) {
    try {
      return ZdsSplitNavigator.of(context);
    } catch (e) {
      return null;
    }
  }

  /// Handles the navigator logic based on the provided [rootNavigator] and [shouldSplit] conditions.
  ///
  /// [context] is the BuildContext of the current widget tree.
  /// [rootNavigator] is the flag to force using the root navigator.
  /// [shouldSplit] is the flag to indicate if the state widget should split.
  /// [splitNavigatorAction] is the action to be performed on the split navigator.
  /// [regularNavigatorAction] is the action to be performed on the regular navigator.
  static Future<T?> _handleNavigation<T extends Object?>({
    required BuildContext context,
    required bool rootNavigator,
    required Future<T?> Function(NavigatorState state) splitNavigatorAction,
    required Future<T?> Function(NavigatorState state) regularNavigatorAction,
  }) {
    final ZdsSplitNavigatorState? state = _safeState(context);
    return !rootNavigator &&
            state != null &&
            state.mounted &&
            state.widget.shouldSplit &&
            state.navigatorKey.currentState != null
        ? splitNavigatorAction(state.navigatorKey.currentState!)
        : regularNavigatorAction(Navigator.of(context, rootNavigator: rootNavigator));
  }

  /// Pushes a new route, either onto the split navigator if available or onto the regular navigator.
  ///
  /// [context] is the BuildContext of the current widget tree.
  /// [route] is the route to be pushed.
  /// [rootNavigator] is an optional flag to force using the root navigator.
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Route<T> route, {
    bool rootNavigator = false,
  }) async {
    return _handleNavigation(
      context: context,
      rootNavigator: rootNavigator,
      regularNavigatorAction: (NavigatorState state) {
        return state.push(route);
      },
      splitNavigatorAction: (NavigatorState state) {
        return state.push(route);
      },
    );
  }

  /// Pushes a details route, either onto the split navigator if available or onto the regular navigator.
  ///
  /// [context] is the BuildContext of the current widget tree.
  /// [route] is the route to be pushed.
  /// [rootNavigator] is an optional flag to force using the root navigator.
  static Future<T?> pushDetails<T extends Object?>(
    BuildContext context,
    Route<T> route, {
    bool rootNavigator = false,
  }) {
    return _handleNavigation(
      context: context,
      rootNavigator: rootNavigator,
      regularNavigatorAction: (NavigatorState state) {
        return state.push(route);
      },
      splitNavigatorAction: (NavigatorState state) {
        return state.pushAndRemoveUntil(route, ModalRoute.withName(ZdsSplitNavigator.emptyRoute));
      },
    );
  }

  /// Pushes a named details route, either onto the split navigator if available or onto the regular navigator.
  ///
  /// [context] is the BuildContext of the current widget tree.
  /// [routeName] is the name of the route to be pushed.
  /// [arguments] are the optional arguments to be passed to the route.
  /// [rootNavigator] is an optional flag to force using the root navigator.
  static Future<T?> pushNamedDetails<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return _handleNavigation(
      context: context,
      rootNavigator: rootNavigator,
      regularNavigatorAction: (NavigatorState state) {
        return state.pushNamed(routeName, arguments: arguments);
      },
      splitNavigatorAction: (NavigatorState state) {
        return state.pushNamedAndRemoveUntil(
          routeName,
          ModalRoute.withName(ZdsSplitNavigator.emptyRoute),
          arguments: arguments,
        );
      },
    );
  }

  /// Pops all routes from the split navigator until the root route.
  ///
  /// [context] is the BuildContext of the current widget tree.
  static void popUntilRoot(BuildContext context) {
    final ZdsSplitNavigatorState? state = _safeState(context);
    if (state != null && state.mounted && state.widget.shouldSplit) {
      state.navigatorKey.currentState?.popUntil(ModalRoute.withName(ZdsSplitNavigator.emptyRoute));
    }
  }

  @override
  State<ZdsSplitNavigator> createState() => ZdsSplitNavigatorState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('shouldSplit', shouldSplit))
      ..add(ObjectFlagProperty<RouteFactory?>.has('onGenerateRoute', onGenerateRoute))
      ..add(ObjectFlagProperty<WidgetBuilder>.has('emptyBuilder', emptyBuilder))
      ..add(DoubleProperty('widthRatio', widthRatio))
      ..add(DiagnosticsProperty<bool>('boxShadowDivider', boxShadowDivider))
      ..add(DiagnosticsProperty<bool>('alwaysSplit', alwaysSplit))
      ..add(DoubleProperty('maxPrimaryWidth', maxPrimaryWidth))
      ..add(DiagnosticsProperty<GlobalKey<NavigatorState>?>('splitNavigatorKey', splitNavigatorKey));
  }
}

/// ZdsSplitNavigatorState is a state class for the ZdsSplitNavigator StatefulWidget.
/// It extends the State class with NavigatorObserver and FrameCallbackMixin mixins.
///
/// It is responsible for managing the nested navigator and keeping track of the routes count
/// as well as the current route in the navigation stack.
class ZdsSplitNavigatorState extends State<ZdsSplitNavigator> with FrameCallbackMixin implements NavigatorObserver {
  /// An integer value to keep track of the number of routes in the nested navigator.
  int routesCount = 0;

  /// A GlobalKey<NavigatorState> used to access the nested navigator's state.
  late GlobalKey<NavigatorState> navigatorKey;

  /// A ValueNotifier<String> that holds the current route's name. By default, it is initialized
  /// with ZdsSplitNavigator.emptyRoute.
  final ValueNotifier<String> currentRoute = ValueNotifier<String>(ZdsSplitNavigator.emptyRoute);

  void _setCurrentRoute() {
    String? newCurrentRoute;
    navigatorKey.currentState?.popUntil((Route<dynamic> route) {
      newCurrentRoute = route.settings.name;
      return true;
    });
    currentRoute.value = newCurrentRoute ?? ZdsSplitNavigator.emptyRoute;
  }

  @override
  void initState() {
    navigatorKey = widget.splitNavigatorKey ?? GlobalKey<NavigatorState>();
    super.initState();
  }

  @override
  NavigatorState? get navigator => null;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    atLast(() {
      setState(() => routesCount++);
      _setCurrentRoute();
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    atLast(() {
      setState(() => routesCount--);
      _setCurrentRoute();
    });
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    atLast(_setCurrentRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    atLast(() {
      setState(() => routesCount--);
      _setCurrentRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shouldSplit) {
      final bool shouldSplit = widget.alwaysSplit || (context.isTablet() && context.isLandscape());
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints layout) {
          double maxWidth = layout.maxWidth;

          maxWidth = shouldSplit
              ? widget.maxPrimaryWidth != null
                  ? min(layout.maxWidth * widget.widthRatio, widget.maxPrimaryWidth!)
                  : layout.maxWidth * widget.widthRatio
              : routesCount > 1
                  ? 0
                  : layout.maxWidth;

          final _SplitContent splitContent = _SplitContent(
            navigatorKey: navigatorKey,
            observer: this,
            boxShadowDivider: widget.boxShadowDivider,
            onGenerateRoute: widget.onGenerateRoute,
            emptyBuilder: widget.emptyBuilder,
          );

          return Stack(
            children: [
              SizedBox(
                width: shouldSplit ? maxWidth : layout.maxWidth,
                child: Semantics(
                  container: true,
                  explicitChildNodes: true,
                  child: widget.primaryWidget,
                ),
              ),
              Positioned.fill(
                left: maxWidth,
                child: Semantics(
                  container: true,
                  explicitChildNodes: true,
                  child: splitContent,
                ),
              ),
            ],
          );
        },
      );
    } else {
      return widget.primaryWidget;
    }
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didStopUserGesture() {}

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('routesCount', routesCount))
      ..add(DiagnosticsProperty<GlobalKey<NavigatorState>>('navigatorKey', navigatorKey))
      ..add(DiagnosticsProperty<ValueNotifier<String>>('currentRoute', currentRoute));
  }
}

class _SplitContent extends StatelessWidget {
  const _SplitContent({
    required this.navigatorKey,
    required this.observer,
    required this.boxShadowDivider,
    required this.onGenerateRoute,
    required this.emptyBuilder,
  });

  final bool boxShadowDivider;
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigatorObserver observer;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final WidgetBuilder emptyBuilder;

  Route<dynamic> _initialRoute() {
    return PageRouteBuilder<dynamic>(
      settings: const RouteSettings(name: ZdsSplitNavigator.emptyRoute),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
          emptyBuilder(context),
      transitionsBuilder:
          (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final List<BoxShadow>? boxShadow = boxShadowDivider
        ? <BoxShadow>[
            BoxShadow(
              color: themeData.colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(-1, 0),
            ),
          ]
        : null;

    final Border? borderSide = boxShadowDivider ? null : Border(left: BorderSide(color: themeData.dividerColor));

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        border: borderSide,
      ),
      child: ClipRRect(
        child: Navigator(
          key: navigatorKey,
          observers: <NavigatorObserver>[observer],
          initialRoute: ZdsSplitNavigator.emptyRoute,
          onGenerateRoute: onGenerateRoute,
          onGenerateInitialRoutes: (_, __) {
            return <Route<dynamic>>[_initialRoute()];
          },
          onPopPage: (Route<dynamic> route, dynamic result) {
            if (!Navigator.of(context).canPop()) {
              Navigator.of(context).pop(result);
              return false;
            }
            return route.didPop(result);
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('boxShadowDivider', boxShadowDivider))
      ..add(DiagnosticsProperty<GlobalKey<NavigatorState>>('navigatorKey', navigatorKey))
      ..add(DiagnosticsProperty<NavigatorObserver>('observer', observer))
      ..add(ObjectFlagProperty<Route<dynamic>? Function(RouteSettings p1)?>.has('onGenerateRoute', onGenerateRoute))
      ..add(ObjectFlagProperty<WidgetBuilder>.has('emptyBuilder', emptyBuilder));
  }
}

/// A custom `PageRouteBuilder` class that creates a new route with a specified builder function.
///
/// The `ZdsSplitPageRouteBuilder` provides a smooth slide transition animation for the new route.
class ZdsSplitPageRouteBuilder<T> extends PageRouteBuilder<T> {
  /// Constructs a `ZdsSplitPageRouteBuilder` with the given `builder` function and optional `settings`.
  ///
  /// The `settings` parameter can be used to provide route settings such as route name and arguments.
  ZdsSplitPageRouteBuilder({
    required this.builder,
    super.settings,
    super.fullscreenDialog,
  }) : super(
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Slide transition is used for the new route.
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

  /// The builder function that returns the widget to display for the new route.
  final Widget Function(BuildContext) builder;
}

/// A custom `PageRouteBuilder` class that creates a new route with a specified builder function.
///
/// The `ZdsFadePageRouteBuilder` provides a fade transition animation for the new route.
class ZdsFadePageRouteBuilder<T> extends PageRouteBuilder<T> {
  /// Constructs a `ZdsFadePageRouteBuilder` with the given `builder` function and optional `settings`.
  ///
  /// The `settings` parameter can be used to provide route settings such as route name and arguments.
  ZdsFadePageRouteBuilder({
    required this.builder,
    super.settings,
    super.fullscreenDialog,
    super.opaque,
  }) : super(
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade transition is used for the new route.
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(animation),
              child: child,
            );
          },
        );

  /// The builder function that returns the widget to display for the new route.
  final Widget Function(BuildContext) builder;
}

/// A custom `PageRouteBuilder` class that creates a new route with a specified builder function.
///
/// The `ZdsNoAnimationPageRouteBuilder` provides no animation for the new route.
class ZdsNoAnimationPageRouteBuilder<T> extends PageRouteBuilder<T> {
  /// Constructs a `ZdsNoAnimationPageRouteBuilder` with the given `builder` function and optional `settings`.
  ///
  /// The `settings` parameter can be used to provide route settings such as route name and arguments.
  ZdsNoAnimationPageRouteBuilder({required this.builder, super.settings, super.fullscreenDialog})
      : super(
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // No animation is used for the new route.
            return child;
          },
        );

  /// The builder function that returns the widget to display for the new route.
  final Widget Function(BuildContext) builder;
}

/// [ZdsAdaptiveTransitionPageRouteBuilder] is a custom route builder that
/// adapts the transition animation based on the device's orientation.
///
/// In landscape mode, it doesn't apply any transition. In other orientations,
/// it applies a slide transition for the new route.
class ZdsAdaptiveTransitionPageRouteBuilder<T> extends PageRouteBuilder<T> {
  /// Constructs a [ZdsAdaptiveTransitionPageRouteBuilder] instance.
  ///
  /// [builder] is the required function that takes a [BuildContext] and returns a [Widget].
  /// [settings] is an optional [RouteSettings] object to configure the route.
  ZdsAdaptiveTransitionPageRouteBuilder({
    required this.builder,
    required this.animate,
    super.settings,
    super.fullscreenDialog,
  }) : super(
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animate) {
              const begin = Offset(1, 0);
              const end = Offset.zero;
              const curve = Curves.ease;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              // Slide transition is used for the new route.
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            } else {
              return child;
            }
          },
        );

  /// The builder function for creating the widget.
  final Widget Function(BuildContext) builder;

  /// Flag to enable for disable the animation.
  final bool animate;
}
