/// A library of Flutter components made by Zebra Technologies based on the Zebra Design System, or ZDS.
///
// The library declaration for 'zds_flutter' is kept here for clarity and organization,
// even though the Dart style guide recommends avoiding library names in this context.
// This helps in maintaining a consistent, descriptive structure for the package and
// its usage, and is particularly useful when exporting several components or utilities
// as part of the public API. The use of a library name at the top aids in identifying
// the package's purpose, especially for consumers of the package.

library;

export 'package:zeta_flutter/zeta_flutter.dart' hide DeviceType, ListDivider;

export 'src/components/atoms.dart';
export 'src/components/molecules.dart';
export 'src/components/organisms.dart';
export 'src/utils/assets.dart';
export 'src/utils/localizations.dart';
export 'src/utils/theme.dart';
export 'src/utils/tools.dart';

/// Name of package
const String packageName = 'zds_flutter';
