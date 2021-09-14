import 'package:bloc/bloc.dart';

class FieldController extends Cubit<String> {
  FieldController() : super("");

  void changeField(String field) {
    emit(field);
  }
}

class LoginSuccessful extends Cubit<bool> {
  LoginSuccessful() : super(false);

  void login() => emit(true);
}
