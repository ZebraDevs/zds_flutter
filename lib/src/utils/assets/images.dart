import 'package:flutter_svg/flutter_svg.dart';

/// A collection of Images and SvgPictures to be used in Zds applications.
///
/// These images are all static and so do not need to have any instantiation.
///
/// For example:
/// ```dart
///  SizedBox(
///   child: ZdsImages.notifications,
///   height: 300,
///   width: 300,
///  ),
/// ```
class ZdsImages {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ZdsImages._();

  /// ![Notifications graphic](https://Zds-components.web.app/assets/png/notifications.png)
  static SvgPicture notifications = SvgPicture.asset('packages/zds_flutter/lib/assets/images/notifications.svg');

  /// ![Chat graphic](https://Zds-components.web.app/assets/png/chat.png)
  static SvgPicture chat = SvgPicture.asset('packages/zds_flutter/lib/assets/images/chat.svg');

  /// ![Notes graphic](https://Zds-components.web.app/assets/png/notes.png)
  static SvgPicture notes = SvgPicture.asset('packages/zds_flutter/lib/assets/images/notes.svg');

  /// ![Fail load graphic](https://Zds-components.web.app/assets/png/load_fail.png)
  static SvgPicture loadFail = SvgPicture.asset('packages/zds_flutter/lib/assets/images/load_fail.svg');

  /// ![Fail load graphic](https://Zds-components.web.app/assets/png/cloud_fail.png)
  static SvgPicture cloudFail = SvgPicture.asset('packages/zds_flutter/lib/assets/images/cloud_fail.svg');

  /// ![Fail load graphicZ](https://Zds-components.web.app/assets/png/server_fail.png)
  static SvgPicture serverFail = SvgPicture.asset('packages/zds_flutter/lib/assets/images/server_fail.svg');

  /// ![Calendar illustration](https://Zds-components.web.app/assets/png/calendar.png)
  static SvgPicture calendar = SvgPicture.asset('packages/zds_flutter/lib/assets/images/calendar.svg');

  /// ![Completed Tasks illustration](https://Zds-components.web.app/assets/png/completedTasks.png)
  static SvgPicture completedTasks = SvgPicture.asset('packages/zds_flutter/lib/assets/images/completed_tasks.svg');

  /// ![Empty Box illustration](https://Zds-components.web.app/assets/png/emptyBox.png)
  static SvgPicture emptyBox = SvgPicture.asset('packages/zds_flutter/lib/assets/images/empty_box.svg');

  /// ![Sad Zebra illustration] (https://Zds-components.web.app/assets/png/sadZebra.png)
  static SvgPicture sadZebra = SvgPicture.asset('packages/zds_flutter/lib/assets/images/sad_zebra.svg');

  /// ![Sleeping Zebra illustration] (https://Zds-components.web.app/assets/png/sleepingZebra.png)
  static SvgPicture sleepingZebra = SvgPicture.asset('packages/zds_flutter/lib/assets/images/sleeping_zebra.svg');

  /// ![Search illustration](https://Zds-components.web.app/assets/png/search.png)
  static SvgPicture search = SvgPicture.asset('packages/zds_flutter/lib/assets/images/search.svg');

  /// ![Punch Illustration]
  static SvgPicture punch = SvgPicture.asset('packages/zds_flutter/lib/assets/images/punch.svg');

  /// ![Map illustration](https://Zds-components.web.app/assets/png/map.png)
  static SvgPicture map = SvgPicture.asset('packages/zds_flutter/lib/assets/images/map.svg');
}
