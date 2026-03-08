import 'dart:html';
import 'package:react/react_client.dart' as react_client;
import 'package:react/react_dom.dart' as react_dom;
import 'package:dart_react_todo/todo_app.dart';

void main() {
  react_client.setClientConfiguration();
  react_dom.render(TodoApp({}), querySelector('#react-root'));
}
