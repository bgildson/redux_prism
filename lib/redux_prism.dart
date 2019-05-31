import 'dart:async';

final StreamController _controller = StreamController.broadcast();

/// used to listen dispatched actions as stream
class StorePrism {
  /// Stream of dispatched actions
  static Stream get actions => _controller.stream;

  /// may be injected in middleware list at store
  static middleware(store, action, next) {
    next(action);
    _controller.add(action);
  }
}
