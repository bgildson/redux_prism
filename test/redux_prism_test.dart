import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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

  testWidgets('should listen dispatched actions in StorePrismListener.listen callback', (WidgetTester tester) async {
    int actionsCounter = 0;

    final store = Store<String>(
      (s, a) => s,
      initialState: 'S',
      middleware: [StorePrism.middleware],
    );

    final widget = StoreProvider<String>(
      store: store,
      child: StorePrismListener(
        listen: (a) {
          actionsCounter++;
        },
        child: Container(),
      ),
    );

    await tester.pumpWidget(widget);

    expect(actionsCounter, 0);

    store.dispatch('I');

    await tester.pumpWidget(widget);

    expect(actionsCounter, 1);
  });
}
