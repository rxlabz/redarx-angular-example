# Redarx with Angular Dart

[Redarx](https://github.com/rxlabz/redarx) is a Dart State management inspired by ngrx<=Redux<=Elm and Parsley (Apache Flex framework).

It is based on a **stream of immutable states "reduced" with a Request-Commands map**.
  
UI emits update request$ => commander maps requests to commands => store receives commands, and use a reduceStream transformer 
to transform the command$ stream to a stream of state$ => UI is updated with the state$ stream

## Config : config.dart

The [config.dart](https://github.com/rxlabz/redarx-angular-example/blob/master/lib/config.dart) file defines :

- the Requests/Commands map
- injected token factory

```dart
const CFG_COMMANDER = const OpaqueToken('cfg.commands');

const DATA_PATH = "todos.json";

final Map<RequestType, CommandBuilder> requestMap = {
  RequestType.LOAD_ALL: AsyncLoadAllCommand.constructor(DATA_PATH),
  RequestType.ADD_TODO: AddTodoCommand.constructor(),
  RequestType.UPDATE_TODO: UpdateTodoCommand.constructor(),
  RequestType.CLEAR_ARCHIVES: ClearArchivesCommand.constructor(),
  RequestType.COMPLETE_ALL: CompleteAllCommand.constructor(),
  RequestType.TOGGLE_SHOW_COMPLETED: ToggleShowArchivesCommand.constructor()
};

CommanderConfig<RequestType> configFactory() {
  return new CommanderConfig<RequestType>(requestMap);
}

const DEFAULT_STORE = const OpaqueToken('redarx.store.default');
Store<Command<TodoModel>, TodoModel> storeFactory() =>
    new Store<Command<TodoModel>, TodoModel>(() => const TodoModel.empty());


final dispatcher = new Dispatcher();

const DISPATCH = const OpaqueToken('redarx.dispatch');
Dispatch dispatchFactory() => dispatcher.dispatch;

const REQUEST$ = const OpaqueToken('redarx.request\$');
Stream<Request> request$Factory() => dispatcher.request$;
```

## Dependency Injection

Redarx classes are injected in the Angular app :

- CommanderConfig
- store
- dispatch method ( Dispatcher )
- request$ stream ( Dispatcher )

```dart
@Component(
selector: 'my-app',
styleUrls: const ['app_component.css'],
templateUrl: 'app_component.html',
viewProviders: const [
  const Provider(CFG_COMMANDER, useFactory: configFactory),
  const Provider(DEFAULT_STORE, useFactory: storeFactory),
  const Provider(DISPATCH, useFactory: dispatchFactory),
  const Provider(REQUEST$, useFactory: request$Factory),
  CommanderService
],
directives: const [TodoForm, TodoFooter, TodoItem])
```

## CommanderService

The Commander service is just an @Injectable wrapper for the commander.

The commander instance is build with injected :

- CommanderConfig<RequestType>
- Store<Command<TodoModel>, TodoModel>
- Stream<Request>

```dart
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
```

## Commands

[Commands](https://github.com/rxlabz/redarx-angular-example/blob/master/lib/state/commands.dart) are simple classes with an exec method.

The `exec()` method create an update instance of the state model and return it.
 
```dart
/// add a new task
class AddTodoCommand extends Command<TodoModel> {
  Todo todo;

  AddTodoCommand(this.todo);

  @override
  TodoModel exec(TodoModel model) =>
      new TodoModel(model.items..add(todo), model.showCompleted);

  static CommandBuilder constructor() {
    return (Todo todo) => new AddTodoCommand(todo);
  }
}
```

## Store.state$

The Store provides a stream of immutables state$. The App Component listen to injected store state$ stream,
 and injected updated values in the children components. 

```dart
class AppComponent {
  TodoModel state;

  Function dispatch;

  AppComponent(CommanderService commander, @Inject(DISPATCH) this.dispatch,
      @Inject(DEFAULT_STORE) Store<Command<TodoModel>, TodoModel> store) {
    store.state$.listen((TodoModel newState) {
      state = newState;
    } );
    loadAll();
  }

  loadAll() {
    dispatch(new Request(RequestType.LOAD_ALL));
  }
  update(Todo todo) {
    dispatch(new Request(RequestType.UPDATE_TODO, withData: todo));
  }
}
```

## Immutable State Model

Each app must define its state [model](https://github.com/rxlabz/redarx-angular-example/blob/master/lib/state/model.dart) class, which must extends AbstracModel.
Abstract Model has a const contructor so the state instances are const.

In this example, we use [built_collection package](https://pub.dartlang.org/packages/built_collection) which provide some immutable data structures.
Here, items are stored in a BuildList.

```dart
class TodoModel extends AbstractModel{

  const TodoModel(this.items, this.showCompleted);

  final BuiltList<Todo> items;

  final bool showCompleted;

  BuiltList<Todo> get todos =>
      new BuiltList<Todo>(items.where((Todo t) => showCompleted ? t.completed : !t.completed));

  int get numCompleted => items.where((t)=>t.completed).length;

  int get numRemaining => items.where((t)=>!t.completed).length;

  TodoModel.empty():items = new BuiltList<Todo>(), showCompleted = false;

  @override
  AbstractModel initial() => new TodoModel.empty();

  @override
  String toString() {
    return '''
TodoModel{
  showCompleted = $showCompleted,
  todos : $todos
}
''';
  }
}
```

### BuildList

A [buildList](https://www.dartdocs.org/documentation/built_collection/1.0.6/built_collection/BuiltList-class.html) instance is immutable, but gives you access to a builder to update value, and rebuild a new updated instance.

```dart

var list = BuildList([1,2,3]);
var newList = list.rebuild((b)=>b.add(4));


```

- Learn more about [built_collection](https://medium.com/@davidmorgan_14314/darts-built-collection-for-immutable-collections-db662f705eff#.bxp1wei28) 