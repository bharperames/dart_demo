import 'package:react/react.dart' as react;

var TodoApp = react.registerComponent(() => new _TodoApp());

// Dart 3: abstract classes used as mixins must be declared as mixin classes
mixin LifecycleLogger {
  void componentWillMount() {
    print("Component will mount...");
  }
}

class _TodoApp extends react.Component with LifecycleLogger {
  // Dart 3: use 'late' for fields injected by React wrapper before componentDidMount
  late String defaultText;
  late int clickCount;
  Map getInitialState() => {
    'todos': [
      {'id': 1, 'text': 'Learn Dart', 'completed': true},
      {'id': 2, 'text': 'Disable Null Safety', 'completed': false},
    ],
    'inputValue': ''
  };

  void addTodo(react.SyntheticFormEvent event) {
    event.preventDefault();
    String newTodoText = state['inputValue'];
    if (newTodoText.trim().isEmpty) return;

    List todos = new List.from(state['todos']);
    
    // Dart 3: optional parameters need explicit non-null default
    String formatTodoText([String prefix = '']) {
      return prefix + ": " + newTodoText;
    }
    
    todos.add({
      'id': new DateTime.now().millisecondsSinceEpoch,
      'text': formatTodoText("Task"),
      'completed': false
    });

    setState({
      'todos': todos,
      'inputValue': ''
    });
  }

  void toggleTodo(int id) {
    List todos = state['todos'].map((todo) {
      if (todo['id'] == id) {
        return {
          'id': todo['id'],
          'text': todo['text'],
          'completed': !todo['completed']
        };
      }
      return todo;
    }).toList();

    setState({'todos': todos});
  }

  void deleteTodo(int id) {
    List todos = new List.from(state['todos']);
    todos.removeWhere((todo) => todo['id'] == id);
    setState({'todos': todos});
  }

  void updateInputValue(react.SyntheticFormEvent event) {
    setState({'inputValue': event.target.value});
  }

  @override
  render() {
    List todos = state['todos'];
    
    var todoElements = todos.map((todo) {
      return react.li({
        'key': todo['id'].toString(),
        'className': todo['completed'] ? 'completed' : ''
      }, [
        react.input({
          'key': 'checkbox',
          'type': 'checkbox',
          'checked': todo['completed'],
          'onChange': (e) => toggleTodo(todo['id'])
        }),
        react.span({'key': 'text'}, todo['text']),
        react.button({
          'key': 'delete',
          'className': 'delete-btn',
          'onClick': (e) => deleteTodo(todo['id'])
        }, 'Delete')
      ]);
    }).toList();

    return react.div({'className': 'todo-app'}, [
      react.h1({'key': 'header'}, 'Dart 2 React Todo'),
      react.form({'key': 'form', 'onSubmit': addTodo, 'className': 'input-container'}, [
        react.input({
          'key': 'input',
          'type': 'text',
          'value': state['inputValue'],
          'onChange': updateInputValue,
          'placeholder': 'Add a new task...'
        }),
        react.button({'key': 'btn', 'type': 'submit', 'className': 'add-btn'}, 'Add')
      ]),
      react.ul({'key': 'list'}, todoElements)
    ]);
  }
}
