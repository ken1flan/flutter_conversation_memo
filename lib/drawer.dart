import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Drawer createDrawer(context) {
  var theme = Theme.of(context);
  var localizations = AppLocalizations.of(context);

  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: theme.primaryColor),
          child: Text(
            localizations.appTitle,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        ListTile(
          title: Text(localizations.topic),
        ),
        ListTile(
          title: Text(localizations.person),
        ),
      ],
    ),
  );
}
