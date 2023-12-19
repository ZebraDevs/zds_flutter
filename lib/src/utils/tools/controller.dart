import '../../../zds_flutter.dart';

/// Generic controller that can control a value that can be updated over time.
///
/// See the implementation of [ZdsDateTimePicker] to see how this can be used.
class ZdsValueController<T> {
  /// Creates a controller for T.
  ZdsValueController({T? value}) : _value = value;

  T? _value;

  /// Gets the current value of T.
  T? get value => _value;

  /// Sets the current value of T and calls updateListener.
  set value(T? newValue) {
    _value = newValue;
    updateListener?.call(_value);
  }

  List<void Function(T? newValue)>? _listeners = <void Function(T? newValue)>[];

  /// Should be used by the state to listen for updates from the calling widget.
  void Function(T? newValue)? updateListener;

  /// Should be used by the state to send updates to the calling widget.
  void notifyListeners(T? value) {
    _value = value;
    if (_listeners == null) return;
    for (final void Function(T? newValue) listener in _listeners!) {
      listener.call(value);
    }
  }

  /// Adds a listener to a list of listeners.
  void addListener(void Function(T? newValue) listener) {
    if (_listeners?.contains(listener) ?? true) return;
    _listeners?.add(listener);
  }

  /// Removes a single listener.
  void removeListener(void Function(T? newValue) listener) {
    _listeners?.remove(listener);
  }

  /// Discards any active listeners.
  /// After this is called the object will not be in a usable state.
  void dispose() {
    _listeners?.forEach(removeListener);
    _listeners = null;
  }
}
