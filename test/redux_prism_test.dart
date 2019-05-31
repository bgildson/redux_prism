import 'package:test/test.dart';

import 'package:redux_prism/redux_prism.dart';

class MessageAction {
  final String message;

  MessageAction({this.message});
}

void main() {
  dynamic store;
  MessageAction action;
  next(action) => action;

  setUp(() {
    store = null;
    action = MessageAction(message: 'hello');
  });

  test('dispatch action and catch on actions stream', () {
    expectLater(StorePrism.actions, emitsInOrder([action]));

    StorePrism.middleware(store, action, next);
  });
}
