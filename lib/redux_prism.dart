library redux_prism;

import 'dart:async';
import 'package:flutter/material.dart';

/// used to listen dispatched actions as stream
class StorePrism {
  /// controller used to generate the actions stream
  static final StreamController _controller = StreamController.broadcast();

  /// Stream of dispatched actions
  static Stream get actions => _controller.stream;

  /// may be injected in middleware list at store
  static middleware(store, action, next) {
    next(action);
    _controller.add(action);
  }
}

/// widget used to listen for dispatched actions in a cleanest way
/// and give the possibility to handle actions in [StatelessWidgets]
/// without have to handle subscriptions
class StorePrismListener extends StatelessWidget {
  final Widget child;
  final void Function(dynamic action) listen;

  const StorePrismListener({
    Key key,
    @required this.child,
    @required this.listen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    StreamBuilder(
      stream: StorePrism.actions,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data != null)
          listen(snapshot.data);
        return child;
      },
    );
}
