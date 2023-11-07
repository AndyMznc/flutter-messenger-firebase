import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersimplon/widgets/app_bar.dart';
import 'package:fluttersimplon/colors.dart';

///Retourne le drawer de l'application
Widget getAppDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: kGrey,
          ),
          child: Text('Bienvenue !'),
        ),
        ListTile(
          title: const Text('Compte'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  appBar: getAppBar(),
                  actions: [
                    SignedOutAction((context) {
                      Navigator.of(context).pushReplacementNamed('/sign-in');
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
