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
            'メニュー',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        ListTile(
          title: Text('話題'),
        ),
        ListTile(
          title: Text('相手'),
        ),
      ],
    ),
  );
}
