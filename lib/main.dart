import 'package:flutter/material.dart';

import 'package:ipcalculator/configurations/theme/theme.dart';
import 'package:ipcalculator/view/views.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Calculator',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: NetworkManagerMainScreen(),
    );
  }
}
