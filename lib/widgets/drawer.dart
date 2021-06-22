import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_conversation_memo/widgets/topic_list_page.dart';
import 'package:flutter_conversation_memo/widgets/person_list_page.dart';

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
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicListPage(),
                ))
          },
        ),
        ListTile(
          title: Text(localizations.person),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonListPage(),
                ))
          },
        ),
      ],
    ),
  );
}
