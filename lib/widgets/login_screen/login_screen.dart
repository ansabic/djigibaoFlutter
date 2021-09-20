import 'dart:ui';

import 'package:djigibao_manager/database/entities/user.dart';
import 'package:djigibao_manager/database/entities/role.dart';
import 'package:djigibao_manager/navigation/destination.dart';
import 'package:djigibao_manager/navigation/navigation.dart';
import 'package:djigibao_manager/widgets/login_screen/login_screen_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatelessWidget {
  final loginNameController = FieldController();
  final loginPassController = FieldController();
  final rolePicked = RolePicked();

  @override
  Widget build(BuildContext context) {
    final navigation = Navigation(context: context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  child: Form(
                    formController: loginNameController,
                    hint: "Name",
                    password: false,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                child: Form(
                  formController: loginPassController,
                  hint: "Password",
                  password: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Colors.transparent),
                  child: DropdownButtonFormField<String>(
                    style: TextStyle(backgroundColor: Colors.transparent),
                    items: Role.values.map((e) {
                      return DropdownMenuItem(
                        value: roleToValue(e),
                        child: Center(
                          child: Text(
                            roleToValue(e),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (role) {
                      rolePicked.changeRole(role ?? roleToValue(Role.Vocal));
                    },
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  child: TextButton(
                    onPressed: () async {
                      if (loginNameController.state.isNotEmpty &&
                          loginPassController.state.isNotEmpty) {
                        await LoginUser().loginUserLocallyAndRemote(
                            User(
                                name: loginNameController.state,
                                role: roleFromValue(rolePicked.rolePicked)),
                            loginPassController.state);
                        navigation.navigateFromStartTo(MainDestination.Home);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                    child: Text(
                      "Confirm",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )),
            ],
          ),
        ));
  }
}

class Form extends StatefulWidget {
  final FieldController formController;
  final bool password;
  final String hint;

  Form(
      {required this.formController,
      required this.hint,
      required this.password});

  @override
  State<StatefulWidget> createState() =>
      _Form(formController: formController, hint: hint, password: password);
}

class _Form extends State<Form> {
  final String hint;
  final bool password;

  _Form(
      {required this.formController,
      required this.hint,
      required this.password});

  final FieldController formController;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 30,
      child: TextFormField(
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1,
        obscureText: password,
        decoration: InputDecoration(hintText: hint),
        controller: textController,
        onChanged: (text) {
          formController.changeField(text);
        },
      ),
    );
  }
}
