import 'package:flutter/material.dart';

import 'pages/home_page..dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(primaryColor: Colors.blueAccent, hintColor: Colors.white)
  ));
}

