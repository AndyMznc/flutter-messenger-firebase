import 'package:flutter/material.dart';
import 'package:fluttersimplon/colors.dart';

final myTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: kBlue),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: kBlue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);
