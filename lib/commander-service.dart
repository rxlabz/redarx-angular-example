import 'package:angular2/core.dart';
import 'package:redarx/redarx.dart';
import 'package:redarx_ng_example/config.dart';
import 'package:redarx_ng_example/state/commands.dart';
import 'package:redarx_ng_example/state/model.dart';

@Injectable()
class CommanderService {

  Commander<Command<TodoModel>, TodoModel> commander;

  CommanderService(
      @Inject(CFG_COMMANDER) CommanderConfig<RequestType> cfg,
      @Inject(DEFAULT_STORE) Store<Command<TodoModel>, TodoModel> store,
      @Inject(REQUEST$) Stream<Request> request$
      ) {

    commander = new Commander<Command<TodoModel>, TodoModel>(cfg, store, request$);
  }
}
