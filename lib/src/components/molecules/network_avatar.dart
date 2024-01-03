import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../zds_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final Center initialsWidget = Center(
      child: Text(
        initials,
        textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1),
        style: textStyle ??
            themeData.textTheme.displaySmall?.copyWith(
              color: (backgroundColor ?? themeData.colorScheme.secondary).onColor,
            ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? preferredSize.height,
        width: size ?? preferredSize.width,
        decoration: BoxDecoration(
          color: backgroundColor ?? themeData.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        child: Semantics(
          label: semanticLabelAvatarDescription,
          child: ExcludeSemantics(
            child: Uri.tryParse(url)?.hasAbsolutePath ?? false
                ? CachedNetworkImage(
                    cacheKey: imgCacheKey,
                    imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: imageProvider, fit: fit),
                        ),
                      );
                    },
                    imageUrl: url,
                    httpHeaders: headers,
                    placeholder: (BuildContext context, _) => initialsWidget,
                    errorWidget: (BuildContext context, _, Object error) => initialsWidget,
                  )
                : initialsWidget,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(48, 48);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('url', url))
      ..add(StringProperty('initials', initials))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DoubleProperty('size', size))
      ..add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(StringProperty('semanticLabelAvatarDescription', semanticLabelAvatarDescription))
      ..add(StringProperty('imgCacheKey', imgCacheKey))
      ..add(DiagnosticsProperty<Map<String, String>?>('headers', headers))
      ..add(EnumProperty<BoxFit?>('fit', fit));
  }
}
