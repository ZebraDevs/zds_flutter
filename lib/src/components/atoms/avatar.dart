import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../zds_flutter.dart';

/// A circular container used to display a user's profile picture or initials.
///
/// When both [image] and [initials] are not null, this widget will prioritize showing the [image]. If both [image] and
/// [initials] are null, the widget will show a circle with a plain background using [backgroundColor].
///
/// It's possible to pass an [onTap] function that will be called whenever the user taps on the avatar. This is
/// typically used for accessing the user's profile page, or toggling selection in [ZdsSelectableListTile].
///
/// See also:
///
///  * [ZdsNetworkAvatar], an avatar that fetches the image from an URL.
///  * [ZdsSelectableListTile], where [ZdsAvatar] is used as the [ZdsSelectableListTile.leading] widget.
///  * [ZdsProfile], where [ZdsAvatar] can be used for [ZdsProfile.avatar].
class ZdsAvatar extends StatelessWidget implements PreferredSizeWidget {
  /// Displays either initials or an image in an optionally tappable circular container.
  /// If given both [initials] and [image], the avatar will always show [image].
  ///
  /// If [size] is not null it must be greater than 0.
  const ZdsAvatar({
    super.key,
    this.image,
    this.initials,
    this.onTap,
    this.size,
    this.textStyle,
    this.backgroundColor,
  }) : assert(size != null ? size > 0 : size == null, 'Size must be greater than 0');

  /// An image that will fill the entire avatar. As the avatar is circular, a square image will not get its corners
  /// shown, but the original image will be intact.
  ///
  /// If [image] and [initials] are both not null, [image] will get priority.
  final Image? image;

  /// The user's initials. Typically up to 3 initials are used, although it can be higher if necessary by changing the
  /// [textStyle] to use a smaller font size and weight.
  ///
  /// If [image] and [initials] are both not null, [image] will get priority.
  final String? initials;

  /// A function called whenever the user taps on the avatar.
  final VoidCallback? onTap;

  /// The avatar's size.
  ///
  /// Must be greater than 0. Defaults to 48 dp.
  final double? size;

  /// The textStyle used for the [initials], if shown.
  ///
  /// Defaults to [TextTheme.displaySmall].
  final TextStyle? textStyle;

  /// The background color of the avatar if [initials] are used.
  ///
  /// Defaults to [ColorScheme.secondary].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? preferredSize.height,
        width: size ?? preferredSize.width,
        decoration: BoxDecoration(
          color: backgroundColor ?? themeData.colorScheme.secondary,
          image: image != null ? DecorationImage(image: image!.image, fit: BoxFit.cover) : null,
          shape: BoxShape.circle,
        ),
        child: (image == null && initials != null)
            ? Center(
                child: Text(
                  initials!,
                  style: textStyle ??
                      themeData.textTheme.displaySmall?.copyWith(
                        color: (backgroundColor ?? themeData.colorScheme.secondary).onColor,
                      ),
                ),
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size(48, 48);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('initials', initials))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DoubleProperty('size', size))
      ..add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle))
      ..add(ColorProperty('backgroundColor', backgroundColor));
  }
}
