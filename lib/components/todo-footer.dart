import 'package:angular2/core.dart';
import 'package:redarx/redarx.dart';
import 'package:redarx_ng_example/state/commands.dart';
import 'package:redarx_ng_example/config.dart';

@Component(
  selector: 'todo-footer',
  templateUrl: 'todo-footer.html'

)
class TodoFooter{

  Dispatch dispatch;

  @Input() int numRemaining = 0;
  @Input() int numCompleted = 0;
  @Input() bool showCompleted = false;


  TodoFooter(@Inject(DISPATCH) this.dispatch);

  completeAll(){
    dispatch(new Request(RequestType.COMPLETE_ALL));
  }
  clear(){
    dispatch(new Request(RequestType.CLEAR_ARCHIVES));
  }

  toggleShowMode(){
    dispatch(new Request(RequestType.TOGGLE_SHOW_COMPLETED));
  }
}