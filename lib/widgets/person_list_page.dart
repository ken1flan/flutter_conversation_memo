import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_conversation_memo/widgets/drawer.dart';
import 'package:flutter_conversation_memo/widgets/person_page.dart';
import 'package:flutter_conversation_memo/models/person.dart';

class PersonListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
      ),
      drawer: createDrawer(context),
      body: ValueListenableBuilder(
        valueListenable: Person.box().listenable(),
        builder: (context, Box<Person> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text(localizations.notFound),
            );
          }
          return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                var currentPerson = box.getAt(index);
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      _editPerson(context, index);
                    },
                    onLongPress: () {
                      // tood
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            currentPerson.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                  timeago.format(currentPerson.updated_at,
                                      locale: 'ja'),
                                  style: TextStyle(
                                    color: theme.disabledColor,
                                    fontSize: 12,
                                  )),
                              SizedBox(width: 5),
                              Text(
                                currentPerson.tags_string,
                                style: TextStyle(
                                  color: theme.disabledColor,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                );
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

  void _editPerson(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonPage(index: index),
        ));
  }
}
