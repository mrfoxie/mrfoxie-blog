import 'Authentication.dart';
import 'package:flutter/material.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementaion auth;
  final VoidCallback onSignedIn;
  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

enum FormType { login, register }

class _LoginRegisterState extends State<LoginRegisterPage> {
  DialogBox dialogBox = new DialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          print("Login in as " + userId);
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          dialogBox.information(context, "Hurry", "Email: " + _email + "\n" + "\n" + "Password: " + _password);
          print("Registred in as " + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error: ", e.toString());
        print("Error: " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xff21254a),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage("images/back.png"), fit: BoxFit.fill),),
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.all(15.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    FocusNode myFocusNode = new FocusNode();
    return [
      SizedBox(
        height: 30.0,
      ),
      logo(),
      SizedBox(
        height: 90.0,
      ),
      new TextFormField(
        style: TextStyle(color: Color(0xffeeeeee)),
        decoration: new InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.email,
            color: Color(0xffeeeeee),
          ),
          labelText: 'Email*',
          labelStyle: TextStyle(
              color:
                  myFocusNode.hasFocus ? Color(0xffeeeeee) : Color(0xffeeeeee)),
          fillColor: Color.fromARGB(255, 255, 100, 0),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          return value.isEmpty ? 'Email Address Required' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
        style: TextStyle(color: Color(0xffeeeeee)),
        decoration: new InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.vpn_key,
            color: Color(0xffeeeeee),
          ),
          labelText: 'Password*',
          labelStyle: TextStyle(
              color:
                  myFocusNode.hasFocus ? Color(0xffeeeeee) : Color(0xffeeeeee)),
          fillColor: Color.fromARGB(255, 255, 100, 0),
        ),
        validator: (value) {
          return value.isEmpty ? 'Password Required' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
        obscureText: true,
      ),
      SizedBox(height: 20.0,)
    ];
  }

  Widget logo() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/Mr. Foxie.png'),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        new FlatButton(
          onPressed: validateAndSubmit,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff833ac7), Color(0xff5e3fd8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        new FlatButton(
          onPressed: moveToRegister,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff833ac7), Color(0xff5e3fd8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        new Text(
          '* are required',
          textDirection: TextDirection.ltr,
        ),
      ];
    } else {
      return [
        new FlatButton(
          onPressed: validateAndSubmit,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff833ac7), Color(0xff5e3fd8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        new FlatButton(
          onPressed: moveToLogin,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff833ac7), Color(0xff5e3fd8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ];
    }
  }
}
