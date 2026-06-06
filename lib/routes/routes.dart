import 'package:flutter/cupertino.dart';
import 'package:p_plus/screens/login.dart';
import 'package:p_plus/screens/home.dart';
import 'package:p_plus/screens/gestor_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> rotasPadrao = {
    'login': (context) => Login(),
    'home': (context) => Home(),
    'gestor': (context) => GestorScreen()
  };
}
