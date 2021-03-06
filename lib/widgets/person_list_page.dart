import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_conversation_memo/widgets/drawer.dart';
import 'package:flutter_conversation_memo/widgets/person_page.dart';
import 'package:flutter_conversation_memo/widgets/person_card.dart';
import 'package:flutter_conversation_memo/models/person.dart';

class PersonListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.personList),
      ),
      drawer: createDrawer(context),
      body: ValueListenableBuilder(
        valueListenable: Person.internalBox.listenable(),
        builder: (context, _box, _) {
          if (Person.isEmpty()) {
            return Center(
              child: Text(localizations.notFound),
            );
          }
          var persons = Person.getAll();
          return ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                var currentPerson = persons[index];
                return PersonCard(context, currentPerson);
              });
        },
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
