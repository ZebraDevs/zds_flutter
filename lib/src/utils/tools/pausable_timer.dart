import 'dart:async';
import 'dart:ui';

/// A custom timer that can be paused and resumed.
///
/// This timer allows for periodic execution of a callback function,
/// with the added functionality to pause and resume the timer.
class ZdsPausableTimer {
  /// Creates a [ZdsPausableTimer] with the specified interval and callback.
  ///
  /// The timer is automatically started upon creation.
  /// - [_interval] specifies the time interval between each tick.
  /// - [_onTick] is the callback function to be called on each tick.
  ZdsPausableTimer(this._interval, this._onTick) {
    start();
  }

  /// Timer object from dart:async.
  Timer? _timer;

  /// The time interval between each tick.
  final Duration _interval;

  /// Callback function to execute on each tick.
  final VoidCallback _onTick;

  /// Flag to indicate if the timer is currently paused.
  bool _isPaused = false;

  /// Starts or restarts the timer.
  ///
  /// If the timer is already running, it will be restarted.
  void start() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(_interval, (timer) {
        _onTick();
      });
    }
  }

  /// Pauses the timer.
  ///
  /// If the timer is currently active, it will be paused.
  /// This method has no effect if the timer is already paused.
  void pause() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _isPaused = true;
    }
  }

  /// Resumes the timer if it is paused.
  ///
  /// This method restarts the timer with the same interval.
  /// If the timer is not paused, this method has no effect.
  void resume() {
    if (_isPaused) {
      start(); // Re-start the timer with the same interval.
      _isPaused = false;
    }
  }

  /// Cancels the timer.
  ///
  /// After calling this method, the timer is stopped and cannot be resumed.
  /// It can only be restarted by creating a new instance of the timer.
  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  /// Returns `true` if the timer is currently paused; otherwise, `false`.
  bool get isPaused => _isPaused;
}
