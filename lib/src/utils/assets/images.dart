import 'package:flutter_svg/flutter_svg.dart';

import '../../../zds_flutter.dart';

/// A collection of Images and SvgPictures to be used in Zebra applications.
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

  /// ![Calendar illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/calendar.png)
  static SvgPicture calendar = SvgPicture.asset('packages/$packageName/lib/assets/images/calendar.svg');

  /// ![Chat illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/chat.png)
  static SvgPicture chat = SvgPicture.asset('packages/$packageName/lib/assets/images/chat.svg');

  /// ![Clock illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/clock.png)
  static SvgPicture clock = SvgPicture.asset('packages/$packageName/lib/assets/images/clock.svg');

  /// ![Cloud fail illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/cloud_fail.png)
  static SvgPicture cloudFail = SvgPicture.asset('packages/$packageName/lib/assets/images/cloud_fail.svg');

  /// ![Completed tasks illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/completed_tasks.png)
  static SvgPicture completedTasks = SvgPicture.asset('packages/$packageName/lib/assets/images/completed_tasks.svg');

  /// ![Connection loss illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/connection_loss.png)
  static SvgPicture connectionLoss = SvgPicture.asset('packages/$packageName/lib/assets/images/connection_loss.svg');

  /// ![Dark mode illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/dark_mode.png)
  static SvgPicture darkMode = SvgPicture.asset('packages/$packageName/lib/assets/images/dark_mode.svg');

  /// ![Empty box illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/empty_box.png)
  static SvgPicture emptyBox = SvgPicture.asset('packages/$packageName/lib/assets/images/empty_box.svg');

  /// ![Internet fail illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/internet_fail.png)
  static SvgPicture internetFail = SvgPicture.asset('packages/$packageName/lib/assets/images/internet_fail.svg');

  /// ![Light mode illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/light_mode.png)
  static SvgPicture lightMode = SvgPicture.asset('packages/$packageName/lib/assets/images/light_mode.svg');

  /// ![Load fail illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/load_fail.png)
  static SvgPicture loadFail = SvgPicture.asset('packages/$packageName/lib/assets/images/load_fail.svg');

  /// ![Map illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/map.png)
  static SvgPicture map = SvgPicture.asset('packages/$packageName/lib/assets/images/map.svg');

  /// ![Notes illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/notes.png)
  static SvgPicture notes = SvgPicture.asset('packages/$packageName/lib/assets/images/notes.svg');

  /// ![Notifications illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/notifications.png)
  static SvgPicture notifications = SvgPicture.asset('packages/$packageName/lib/assets/images/notifications.svg');

  /// ![Sad Zebra illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/sad_zebra.png)
  static SvgPicture sadZebra = SvgPicture.asset('packages/$packageName/lib/assets/images/sad_zebra.svg');

  /// ![Search illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/search.png)
  static SvgPicture search = SvgPicture.asset('packages/$packageName/lib/assets/images/search.svg');

  /// ![Server fail illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/server_fail.png)
  static SvgPicture serverFail = SvgPicture.asset('packages/$packageName/lib/assets/images/server_fail.svg');

  /// ![Sleeping Zebra illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/sleeping_zebra.png)
  static SvgPicture sleepingZebra = SvgPicture.asset('packages/$packageName/lib/assets/images/sleeping_zebra.svg');

  /// ![System mode illustration](https://raw.githubusercontent.com/ZebraDevs/zds_flutter/main/doc/assets/system_mode.png)
  static SvgPicture systemMode = SvgPicture.asset('packages/$packageName/lib/assets/images/system_mode.svg');
}
