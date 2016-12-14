import 'package:angular2/core.dart';
import 'package:redarx/redarx.dart';
import 'package:redarx_ng_example/config.dart';
import 'package:redarx_ng_example/state/commands.dart';
import 'package:redarx_ng_example/state/model.dart';

@Component(
    selector: 'todo-form',
    template:
        "<div><input #fld type='text'/><button (click)='add(fld.value)'>+</button></div>")
class TodoForm {
  // typedef @see[Dispatch]
  Dispatch dispatch;

  TodoForm(@Inject(DISPATCH) this.dispatch);

  add(String task) {
    print('TodoForm.add  dispatch ${dispatch}');
    dispatch(new Request(RequestType.ADD_TODO, withData: new Todo(task)));
  }
}
