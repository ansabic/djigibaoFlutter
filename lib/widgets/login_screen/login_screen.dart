import 'dart:ui';

import 'package:djigibao_manager/widgets/login_screen/login_screen_blocs.dart';
import 'package:djigibao_manager/widgets/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatelessWidget {
  final loginNameController = FieldController();
  final loginPassController = FieldController();

  @override
  Widget build(BuildContext context) {
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
                  child:
                      Form(formController: loginNameController, hint: "Name")),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                child: Form(
                  formController: loginPassController,
                  hint: "Password",
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  child: TextButton(
                    onPressed: () {
                      if (loginNameController.state.isNotEmpty &&
                          loginPassController.state.isNotEmpty)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple)),
                    child: Text(
                      "Confirm",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ))
            ],
          ),
        ));
  }
}

class Form extends StatefulWidget {
  final FieldController formController;
  final String hint;

  Form({required this.formController, required this.hint});

  @override
  State<StatefulWidget> createState() =>
      _Form(formController: formController, hint: hint);
}

class _Form extends State<Form> {
  final String hint;

  _Form({required this.formController, required this.hint});

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
        decoration: InputDecoration(hintText: hint),
        controller: textController,
        onChanged: (text) {
          formController.changeField(text);
        },
      ),
    );
  }
}
