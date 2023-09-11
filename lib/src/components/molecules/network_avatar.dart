import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../zds_flutter.dart';

/// A circular container used to display a user's profile picture fetched from the internet.
///
/// This widget will prioritize showing the image fetched from [url]. If an image can't be loaded, the avatar will show
/// a circle with a plain background using [backgroundColor] and the user's [initials].
///
/// The image fetched from [url] is not loaded again every time, but is rather cached to reduce network usage.
///
/// See also:
///
///  * [ZdsAvatar], an avatar used to display an image that is stored locally, or just the initials.
///  * [CachedNetworkImage], which this avatar uses to not have to download the image every time.
class ZdsNetworkAvatar extends StatelessWidget implements PreferredSizeWidget {
  /// The URL from which to fetch the image.
  final String url;

  /// Fallback text shown while the image is loading, or if the image couldn't be loaded.
  ///
  /// The image will always get priority.
  final String initials;

  /// A function called whenever the user taps on this avatar.
  final VoidCallback? onTap;

  /// The avatar's size.
  ///
  /// Must be greater than 0. Defaults to 48 dp.
  final double? size;

  /// The textStyle used for the [initials], if shown.
  ///
  /// Defaults to [TextTheme.displaySmall].
  final TextStyle? textStyle;

  /// The background color of this avatar if the [initials] are shown.
  ///
  /// Defaults to [ColorScheme.secondary].
  final Color? backgroundColor;

  /// Semantic label for description of image
  final String? semanticLabelAvatarDescription;

  /// It the key which will be used in the CachedNetworkImage as cachekey for refreshing image.
  final String? imgCacheKey;

  /// Optional headers for the http request of the image url.
  final Map<String, String>? headers;

  /// How to inscribe the image into the space allocated during layout.
  final BoxFit? fit;

  /// An avatar that gets its image from an URL.
  const ZdsNetworkAvatar({
    required this.initials,
    this.url = '',
    this.onTap,
    this.size,
    this.textStyle,
    this.backgroundColor,
    this.semanticLabelAvatarDescription,
    this.imgCacheKey,
    this.headers,
    this.fit,
    super.key,
  }) : assert(size != null ? size >= 0 : size == null, 'Size must be greater than 0');

  @override
  Widget build(BuildContext context) {
    final initialsWidget = Center(
      child: Text(
        initials,
        textScaleFactor: 1,
        style: textStyle ??
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: calculateTextColor(backgroundColor ?? Theme.of(context).colorScheme.secondary),
                ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? preferredSize.height,
        width: size ?? preferredSize.width,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        child: Semantics(
          label: semanticLabelAvatarDescription,
          child: ExcludeSemantics(
            child: Uri.tryParse(url)?.hasAbsolutePath ?? false
                ? CachedNetworkImage(
                    cacheKey: imgCacheKey,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: imageProvider, fit: fit),
                        ),
                      );
                    },
                    imageUrl: url,
                    httpHeaders: headers,
                    placeholder: (context, _) => initialsWidget,
                    errorWidget: (context, _, error) => initialsWidget,
                  )
                : initialsWidget,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(48, 48);

  /// Sets the default text color based on the background color.
  Color calculateTextColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.light ? ZdsColors.darkGrey : ZdsColors.white;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('url', url));
    properties.add(StringProperty('initials', initials));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DoubleProperty('size', size));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(StringProperty('semanticLabelAvatarDescription', semanticLabelAvatarDescription));
    properties.add(StringProperty('imgCacheKey', imgCacheKey));
    properties.add(DiagnosticsProperty<Map<String, String>?>('headers', headers));
    properties.add(EnumProperty<BoxFit?>('fit', fit));
  }
}
