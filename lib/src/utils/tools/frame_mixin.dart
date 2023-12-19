import 'package:flutter/material.dart';

/// This mixin could be used in the methods where you want to do some work after you are
///
/// This mixin is supposed to be a replacement for the use of `WidgetsBinding.instance?.addPostFrameCallback()`.
mixin FrameCallbackMixin {
  /// Post-frame callbacks cannot be unregistered. They are called exactly once.
  ///
  ///  This is a wrapper around `WidgetsBinding.instance?.addPostFrameCallback`, which is commonly used.
  ///
  /// This mixin should be used instead as it is easier to read and understand.
  void atLast(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback.call());
  }
}
