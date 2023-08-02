import 'package:debug_friend/debug_friend.dart';
import 'package:debug_friend/src/utils/utils.dart';
import 'package:debug_friend/src/widgets/actions/app_console/app_console.dart';
import 'package:debug_friend/src/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugFriendView extends StatefulWidget {
  const DebugFriendView({
    required this.builder,
    this.enabled = kDebugMode,
  });

  final WidgetBuilder builder;
  final bool enabled;

  @override
  State<DebugFriendView> createState() => _DebugFriendViewState();
}

class _DebugFriendViewState extends State<DebugFriendView> {

  final console = ConsoleManager();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: console,
      child: Localizations(
        locale: const Locale("it"),
        delegates: const [],
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              widget.builder.call(context),
              if (widget.enabled)
                _InnerDebugFriendView(
                    enabled: widget.enabled, console: console,),
            ],
          ),
        ),
      ),
    );
  }
}

class _InnerDebugFriendView extends StatefulWidget {
  _InnerDebugFriendView({
    Key? key,
    required this.enabled,
    required this.console,
  })  : _bottomSheetManager = BottomSheetManager(),
        super(key: key);

  final ConsoleManager console;
  final Widget icon = const Icon(Icons.bug_report);
  final bool enabled;
  final BottomSheetManager _bottomSheetManager;

  @override
  State<_InnerDebugFriendView> createState() => _InnerDebugFriendViewState();
}

class _InnerDebugFriendViewState extends State<_InnerDebugFriendView> {

  late final theme = DebugFriendTheme.fromFlutterTheme(context);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 40,
      child: DebugFriendButton(
        theme: theme,
        onTap: () => _onButtonTap(context, theme),
        child: widget.icon,
      ),
    );
  }

  void _onButtonTap(BuildContext context, DebugFriendTheme theme) {
    widget._bottomSheetManager.showBottomSheet(
      context,
      theme: theme,
      builder: (ctx) {
        return Provider.value(
          value: widget.console,
          child: DebugFriendMenu(
            theme: theme,
            headers: const [
              Icons.list_outlined,
              Icons.app_settings_alt,
              Icons.folder_open,
              Icons.touch_app,
              // Icons.extension,
            ],
            bodies: [
              AppConsole(theme: theme,),
              AppInfoBody(theme: theme),
              AppDataBody(theme: theme),
              AppActionsBody(theme: theme),
            ],
          ),
        );
      },
    );
  }
}
