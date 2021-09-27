import 'package:bloc/bloc.dart';
import 'package:djigibao_manager/navigation/destination.dart';

class MainScreenManager extends Cubit<HomeDestination> {
  MainScreenManager() : super(HomeDestination.Songs);

  void changeDestination(int position) {
    switch (position) {
      case 0:
        emit(HomeDestination.Songs);
        break;
      case 1:
        emit(HomeDestination.Events);
        break;
      case 2:
        emit(HomeDestination.Topics);
        break;
      case 3:
        emit(HomeDestination.Settings);
        break;
    }
  }
}
