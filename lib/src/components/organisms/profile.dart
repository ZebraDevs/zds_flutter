import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zds_flutter.dart';

/// A component used to show a snapshot of someone's profile.
///
/// It is possible to allow users to do actions related to the profile, like editing or favoriting, by using the
/// [action] parameter.
///
/// ```dart
/// ZdsProfile(
///   avatar: ZdsAvatar(
///     image: Image()
///     nameText: const Text('Average Joe'),
///     jobTitleText: const Text('Store Employee'),
///     action: ZdsButton.text(
///       onTap: () => editProfile(),
///       child: Row(
///         children: [
///           const Icon(ZdsIcons.edit).paddingOnly(right: 4),
///           const Text('Edit'),
///         ],
///       ),
///     ),
///   ),
/// )
///  ```
///
/// See also:
///
///  [ZdsNetworkAvatar] and [ZdsAvatar], used to show someone's profile picture.
class ZdsProfile extends StatelessWidget {
  /// The user's avatar.
  ///
  /// Typically a [ZdsNetworkAvatar] or a [ZdsAvatar].
  final PreferredSizeWidget avatar;

  /// The user's name.
  final Text nameText;

  /// The user's job title or position.
  final Text jobTitleText;

  /// A button at the end of the component to perform actions.
  ///
  /// Typically a [ZdsButton.text] or an [IconButton].
  final Widget? action;

  /// Semantic label title.
  final String? semanticLabelTitle;

  /// Semantic label subtitle.
  final String? semanticLabelSubTitle;

  /// Creates a snapshot of someone's profile.
  const ZdsProfile({
    required this.avatar,
    required this.nameText,
    required this.jobTitleText,
    this.semanticLabelTitle,
    this.semanticLabelSubTitle,
    super.key,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        avatar,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Semantics(
                      label: semanticLabelTitle,
                      child: nameText.textStyle(
                        Theme.of(context).textTheme.displaySmall?.copyWith(height: 1.2, fontSize: 20),
                      ),
                    ),
                  ),
                  if (action != null)
                    action!.applyTheme(Theme.of(context).shrunkenButtonsThemeData).frameConstrained(
                          minWidth: 0,
                          maxWidth: double.infinity,
                          minHeight: 0,
                          maxHeight: kMaxActionHeight,
                        ),
                ],
              ),
              Semantics(
                label: semanticLabelSubTitle,
                child: jobTitleText.textStyle(
                  Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ],
          ).paddingOnly(left: 24),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('semanticLabelTitle', semanticLabelTitle))
      ..add(StringProperty('semanticLabelSubTitle', semanticLabelSubTitle));
  }
}
