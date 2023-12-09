import 'package:flutter/material.dart';

final ThemeData customTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromRGBO(240, 248, 255, 1.0),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ));
