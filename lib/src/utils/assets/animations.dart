import '../../../zds_flutter.dart';

/// A collection of animations to be used in Zds applications.
///
/// The variables are JSON assets so will need to be used with the Lottie package: https://pub.dev/packages/lottie
///
/// Usage:
/// ```dart
/// Lottie.asset(ZdsAnimations.taskComplete)
/// ```
class ZdsAnimations {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ZdsAnimations._();

  /// An animated approval stamp
  static const String approvalStamped = 'packages/$packageName/lib/assets/animations/approval_stamped.json';

  /// An animated checkmark inside a circle
  static const String check = 'packages/$packageName/lib/assets/animations/check.json';

  /// An animated checkmark inside an animated circle
  static const String checkCircle = 'packages/$packageName/lib/assets/animations/two_checks.json';

  /// An animated checkmark with a glimmer around it
  static const String checkGlimmer = 'packages/$packageName/lib/assets/animations/check_glimmer.json';

  /// An rippling checkmark in a circle
  static const String checkRipple = 'packages/$packageName/lib/assets/animations/check_ripple.json';

  /// An animated thumbs up
  static const String thumbsUp = 'packages/$packageName/lib/assets/animations/thumbs_up.json';

  /// An animated thumbs up next to 'approved' text
  static const String thumbsUpApproved = 'packages/$packageName/lib/assets/animations/thumbs_up_approved.json';

  /// A clock animated followed by an animated check
  static const String timeApproved = 'packages/$packageName/lib/assets/animations/time_approved.json';

  /// A clock animated followed by an animated thumbs up in a box
  static const String timeApprovedBox = 'packages/$packageName/lib/assets/animations/time_approved_box.json';

  /// A clock animated followed by an animated thumbs up with a glimmer
  static const String timeApprovedGlimmer = 'packages/$packageName/lib/assets/animations/time_approved_glimmer.json';

  /// A timecard being approved
  static const String timecardTapping = 'packages/$packageName/lib/assets/animations/timecard_tapping.json';

  /// Two animated checkmarks on a page
  static const String twoChecks = 'packages/$packageName/lib/assets/animations/check_circle.json';
}
