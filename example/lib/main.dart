import 'dart:async';

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
          StorePrism.middleware
        ]
      ),
      child: MaterialApp(
        title: 'Redux Prism',
        home: MessagePage()
      )
    );
}

@immutable
class MessageAction {
  final String message;

  MessageAction({this.message});

  @override
  String toString() => 'MessageAction { message: "$message" }';
}

class MessagePage extends StatefulWidget{
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  StreamSubscription _actionsSubscription;

  @override
  void initState() {
    super.initState();
    _actionsSubscription = StorePrism.actions
      .listen((action) {
        _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(action.toString())));
      });
  }

  @override
  void dispose() {
    _actionsSubscription.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) =>
    Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Redux Prism')),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _messageController,
            decoration: InputDecoration(labelText: 'Message')
          ),
          StoreBuilder<String>(
            builder: (_, store) =>
              OutlineButton(
                onPressed: () =>
                  store.dispatch(MessageAction(message: _messageController.text)),
                child: Text('SEND')
              )
          )
        ]
      )
    );
}
