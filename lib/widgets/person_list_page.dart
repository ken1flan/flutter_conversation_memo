import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_conversation_memo/widgets/drawer.dart';
import 'package:flutter_conversation_memo/widgets/person_page.dart';

class PersonListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
      ),
      drawer: createDrawer(context),
      body: Center(
        child: Text(localizations.notFound),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewPerson(context);
        },
        tooltip: localizations.personListAdd,
        child: Icon(Icons.add),
      ),
    );
  }

  void _createNewPerson(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonPage(),
        ));
  }
}
