import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_conversation_memo/widgets/topic_page.dart';
import 'package:flutter_conversation_memo/models/topic.dart';

class TopicCard extends Card {
  TopicCard(BuildContext context, int index, Topic topic)
      : super(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              _editTopic(context, index);
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('${topic.summary}を消しますが、よろしいですか？'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Topic.box().deleteAt(index);
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes'),
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
                    Row(
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
                    SizedBox(height: 5),
                  ]),
            ),
          ),
        );

  static void _editTopic(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopicPage(index: index),
        ));
  }
}
