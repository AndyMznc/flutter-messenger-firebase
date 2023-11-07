import 'package:flutter/material.dart';
import 'package:fluttersimplon/widgets/app_bar.dart';

abstract class ListPage extends StatelessWidget {
  const ListPage({super.key});

  ///Retourne le drawer si besoin
  Widget? getDrawer(BuildContext context) {
    return null;
  }

  ///Le titre présent dans l'app bar
  Widget? getTitle() {
    return null;
  }

  ///Retourne le contenu de l'écran
  Widget getBody();

  ///Le bouton en bas à droite
  Widget? getFloatingActionButton(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(title: getTitle()),
      drawer: getDrawer(context),
      body: getBody(),
      floatingActionButton: getFloatingActionButton(context),
    );
  }
}
