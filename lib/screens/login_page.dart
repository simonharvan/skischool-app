import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skischool/data/auth.dart';
import 'package:skischool/utils/logger.dart';
import 'package:skischool/utils/popup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Prihlásenie'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
//                    border: InputBorder.none,
//                    hintText: 'Enter email',
                  labelText: 'Zadajte email'),
              controller: email,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(labelText: 'Zadajte heslo'),
              controller: password,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(16.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                login(_auth);
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login(Auth auth) async {
    Log.d('Login ' + email.text + ' ' + password.text);

    if (validate(email.text, password.text)) {
      final snackbar = SnackBar(
        duration: Duration(seconds: 30),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
              child: Text("Prihlasujem ..."),
            )
          ],
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);

      try {
        var result = await auth.login(email.text, password.text);
        loginSuccess(result);
      } catch (error) {
        loginError();
      }
    } else {
      showAlertPopup(context, 'Chyba', 'Zle zadany email alebo heslo');
    }
  }

  bool validate(String email, String password) {
    if (email.length < 3) {
      return false;
    }
    if (password.length < 3) {
      return false;
    }
    return true;
  }

  loginSuccess(bool value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    Log.d('Login finished $value');
  }

  loginError() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    showAlertPopup(context, 'Chyba', 'Zle zadany email alebo heslo');
  }
}
