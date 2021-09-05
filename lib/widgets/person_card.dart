import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_conversation_memo/widgets/person_page.dart';
import 'package:flutter_conversation_memo/models/person.dart';

class PersonCard extends Card {
  PersonCard(BuildContext context, int index, Person person)
      : super(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              _editPerson(context, person);
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    var localizations = AppLocalizations.of(context);
                    return AlertDialog(
                      content:
                          Text(localizations.personDeleteConfirm(person.name)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(localizations.personDeleteConfirmNo),
                        ),
                        TextButton(
                          onPressed: () async {
                            await person.delete();
                            Navigator.of(context).pop();
                          },
                          child: Text(localizations.personDeleteConfirmYes),
                        )
                      ],
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5),
                  Text(
                    person.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(timeago.format(person.updated_at, locale: 'ja'),
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 12,
                          )),
                      SizedBox(width: 5),
                      Text(
                        person.tags_string,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
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

  static void _editPerson(BuildContext context, Person person) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonPage(person),
        ));
  }
}
