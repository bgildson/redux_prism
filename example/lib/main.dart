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
