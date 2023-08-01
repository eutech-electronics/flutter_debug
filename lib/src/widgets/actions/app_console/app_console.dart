import 'package:debug_friend/debug_friend.dart';
import 'package:debug_friend/src/utils/console_manager.dart';
import 'package:debug_friend/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppConsole extends StatefulWidget {
  const AppConsole({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final DebugFriendTheme theme;

  @override
  State<AppConsole> createState() => _AppConsoleState();
}

class _AppConsoleState extends State<AppConsole> {

  late final _theme = DebugFriendTheme.fromFlutterTheme(context);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: context
            .watch<ConsoleManager>()
            .getLines()
            .length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return CommonActionBody(
            theme: _theme,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                context.watch<ConsoleManager>().getLines()[1],
                style: _theme.bodyText,
              ),
            ),
          );
        },
      ),
    );
  }
}
