import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_conversation_memo/widgets/topic_page.dart';
import 'package:flutter_conversation_memo/models/topic.dart';

class TopicCard extends Card {
  TopicCard(BuildContext context, Topic topic)
      : super(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              _editTopic(context, topic);
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    var localizations = AppLocalizations.of(context);

                    return AlertDialog(
                      content:
                          Text(localizations.topicDeleteConfirm(topic.summary)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(localizations.topicDeleteConfirmNo),
                        ),
                        TextButton(
                          onPressed: () async {
                            await topic.delete();
                            Navigator.of(context).pop();
                          },
                          child: Text(localizations.topicDeleteConfirmYes),
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
                      topic.summary,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(timeago.format(topic.updated_at, locale: 'ja'),
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: 12,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(topic.tags_string,
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                  ]),
            ),
          ),
        );

  static void _editTopic(BuildContext context, Topic topic) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopicPage(topic: topic),
        ));
  }
}
