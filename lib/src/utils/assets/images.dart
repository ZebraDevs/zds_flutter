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

  /// ![Calendar illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/calendar.png)
  static SvgPicture calendar = SvgPicture.asset('packages/zds_flutter/lib/assets/images/calendar.svg');

  /// ![Chat graphic](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/chat.png)
  static SvgPicture chat = SvgPicture.asset('packages/zds_flutter/lib/assets/images/chat.svg');

  /// ![Fail load graphic](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/cloud_fail.png)
  static SvgPicture cloudFail = SvgPicture.asset('packages/zds_flutter/lib/assets/images/cloud_fail.svg');

  /// ![Completed Tasks illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/completed_tasks.png)
  static SvgPicture completedTasks = SvgPicture.asset('packages/zds_flutter/lib/assets/images/completed_tasks.svg');

  /// ![Map illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/connection_dead.png)
  static SvgPicture connectionDead = SvgPicture.asset('packages/zds_flutter/lib/assets/images/connection_dead.svg');

  /// ![Empty Box illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/empty_box.png)
  static SvgPicture emptyBox = SvgPicture.asset('packages/zds_flutter/lib/assets/images/empty_box.svg');

  /// ![Fail load graphic](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/internet_fail.png)
  static SvgPicture internetFail = SvgPicture.asset('packages/zds_flutter/lib/assets/images/internet_fail.svg');

  /// ![Fail load graphic](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/load_fail.png)
  static SvgPicture loadFail = SvgPicture.asset('packages/zds_flutter/lib/assets/images/load_fail.svg');

  /// ![Map illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/load_fail.png)
  static SvgPicture map = SvgPicture.asset('packages/zds_flutter/lib/assets/images/map.svg');

  /// ![Notes graphic](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/notes.png)
  static SvgPicture notes = SvgPicture.asset('packages/zds_flutter/lib/assets/images/notes.svg');

  /// ![Notifications graphic](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/notifications.png)
  static SvgPicture notifications = SvgPicture.asset('packages/zds_flutter/lib/assets/images/notifications.svg');

  /// ![Sad Zebra illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/sad_zebra.png)
  static SvgPicture sadZebra = SvgPicture.asset('packages/zds_flutter/lib/assets/images/sad_zebra.svg');

  /// ![Search illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/search.png)
  static SvgPicture search = SvgPicture.asset('packages/zds_flutter/lib/assets/images/search.svg');

  /// ![Fail load graphic](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/server_fail.png)
  static SvgPicture serverFail = SvgPicture.asset('packages/zds_flutter/lib/assets/images/server_fail.svg');

  /// ![Sleeping Zebra illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/assets/images/sleeping_zebra.png)
  static SvgPicture sleepingZebra = SvgPicture.asset('packages/zds_flutter/lib/assets/images/sleeping_zebra.svg');
}
