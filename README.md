# redux_prism

[![Build Status](https://travis-ci.org/bgildson/redux_prism.svg?branch=master)](https://travis-ci.org/bgildson/redux_prism)
[![Coverage Status](https://coveralls.io/repos/github/bgildson/redux_prism/badge.svg?branch=master)](https://coveralls.io/github/bgildson/redux_prism?branch=master)
[![pub package](https://img.shields.io/pub/v/redux_prism.svg)](https://pub.dartlang.org/packages/redux_prism)

Library used to easily access dispatched actions in a [Redux](https://pub.dartlang.org/packages/redux) Store. The library defines a pattern to catch new dispatched actions and listen to them in a reactive context. The `StorePrism.middleware` works like a proxy in the store middlewares and add every new action in the `StorePrism.actions` stream.

## Usage
```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_prism/redux_prism.dart';

void main() => runApp(MessageApp());

class MessageApp extends StatelessWidget {
  Widget build(BuildContext context) =>
    StoreProvider<String>(
      store: Store<String>(
        (state, action) => state,
        middleware: [
          // register StorePrism "proxy" middleware
          StorePrism.middleware
        ],
      ),
      child: MaterialApp(
        title: 'Redux Prism',
        home: MessagePage()
      ),
    );
}

@immutable
class MessageAction {
  final String message;

  MessageAction({this.message});

  @override
  String toString() => 'MessageAction { message: $message }';
}

class MessagePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _messageController = TextEditingController();

  MessagePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    StorePrismListener(
      listen: (action) =>
        _scaffoldKey.currentState
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(action.toString()))),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Redux Prism')),
        body: Column(
          children: <Widget>[
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message')
            ),
            StoreConnector<String, Function(String)>(
              converter: (Store<String> store) =>
                (message) => store.dispatch(MessageAction(message: message)),
              rebuildOnChange: false,
              builder: (_, dispatchMessageAction) =>
                OutlineButton(
                  onPressed: () => dispatchMessageAction(_messageController.text),
                  child: Text('SEND')
                )
            ),
          ],
        ),
      ),
    );
}
```
