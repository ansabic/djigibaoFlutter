import 'package:bloc/bloc.dart';

class FieldController extends Cubit<String>{
  FieldController() : super("");

  void changeField(String field) {
    emit(field);
  }

}
