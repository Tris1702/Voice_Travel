import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voice_travel/core/bloc_base.dart';
import 'package:voice_travel/data/model/translate_record.dart';
import 'package:voice_travel/data/service/database_service.dart';

class HistoryBloc extends BlocBase {

  final database = GetIt.I<DatabaseService>();
  BehaviorSubject<List<TranslateRecord>> translateHistories = BehaviorSubject.seeded(List.empty(growable: true));

  @override
  void dispose() {
    translateHistories.close();
  }

  @override
  void init() {
    _getAllHistories();
  }

  _getAllHistories() async {
    final histories = await database.getHistory();
    translateHistories.sink.add(histories);
  }

  removeAll() async {
    await database.deleteAllHistory();
    translateHistories.sink.add(List.empty());
  }

  removeRecord(int index) async {
    await database.deleteFav(translateHistories.value.elementAt(index)).then((_) {
      translateHistories.value.removeAt(index);
      translateHistories.sink.add(translateHistories.value);
    });
  }

  navigateBack() {
    appNavigator.pop();
  }
}