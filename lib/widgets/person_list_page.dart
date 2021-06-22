import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_conversation_memo/widgets/drawer.dart';

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
    );
  }
}
