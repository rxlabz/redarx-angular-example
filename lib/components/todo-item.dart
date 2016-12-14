import 'package:angular2/core.dart';
import 'package:redarx_ng_example/state/model.dart';

@Component(
  selector: 'todo-item',
  templateUrl: 'todo-item.html'
)
class TodoItem{

  @Input() Todo todo;

  @Output('onUpdate') EventEmitter<Todo> update$ = new EventEmitter<Todo>();

  complete( bool value ){
    print('TodoItem.complete  value ${value}');
    update$.add(new Todo(todo.label, value, todo.uid));
  }

}