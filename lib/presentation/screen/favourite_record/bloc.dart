import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voice_travel/core/bloc_base.dart';

import '../../../data/model/translate_record.dart';
import '../../../data/service/database_service.dart';

class FavouriteBloc extends BlocBase {

  final database = GetIt.I<DatabaseService>();
  BehaviorSubject<List<TranslateRecord>> translateFavourite = BehaviorSubject.seeded(List.empty(growable: true));

  @override
  void dispose() {
    translateFavourite.close();
  }

  @override
  void init() {
    _getAllFavourite();
  }

  _getAllFavourite() async {
    final histories = await database.getFav();
    translateFavourite.sink.add(histories);
  }

  removeAll() async {
    await database.deleteAllFav();
    translateFavourite.sink.add(List.empty());
  }

  removeRecord(int index) async {
    await database.deleteFav(translateFavourite.value.elementAt(index)).then((_) {
      translateFavourite.value.removeAt(index);
      translateFavourite.sink.add(translateFavourite.value);
    });

  }

  navigateBack() {
    appNavigator.pop();
  }
}