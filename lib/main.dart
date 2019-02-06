import 'package:flutter/material.dart';

import 'pages/contato_detalhe_page.dart';
import 'pages/home_page..dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(primaryColor: Colors.blueAccent, hintColor: Colors.black)
    // Não mostrar a legenda "debug" debugShowCheckedModeBanner: false,
  ));
}

