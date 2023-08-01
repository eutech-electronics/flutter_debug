import 'package:debug_friend/debug_friend.dart';
import 'package:debug_friend/src/utils/utils.dart';
import 'package:debug_friend/src/widgets/actions/app_console/app_console.dart';
import 'package:debug_friend/src/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugFriendView extends StatelessWidget {
  const DebugFriendView({
    required this.builder,
    this.enabled = kDebugMode,
  });

  final WidgetBuilder builder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      debugShowCheckedModeBanner: false,
      home: Provider(
          create: (_) => ConsoleManager(),
          child: _InnerDebugFriendView(builder: builder, enabled: enabled,),
      ),
    );
  }
}

class _InnerDebugFriendView extends StatefulWidget {
  _InnerDebugFriendView({
    Key? key,
    required this.builder,
    required this.enabled,
  })  : _bottomSheetManager = BottomSheetManager(),
        super(key: key);

  final Widget icon = const Icon(Icons.bug_report);
  final WidgetBuilder builder;
  final bool enabled;
  final BottomSheetManager _bottomSheetManager;

  @override
  State<_InnerDebugFriendView> createState() => _InnerDebugFriendViewState();
}

class _InnerDebugFriendViewState extends State<_InnerDebugFriendView> {
  @override
  void initState() {
    if (widget.enabled && kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) => _insertOverlay(context),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context);
  }

  void _insertOverlay(BuildContext context) {
    final theme = DebugFriendTheme.fromFlutterTheme(context);
    return Overlay.of(context).insert(
      OverlayEntry(
        builder: (context) {
          return DebugFriendButton(
            theme: theme,
            onTap: () => _onButtonTap(context, theme),
            child: widget.icon,
          );
        },
      ),
    );
  }

  void _onButtonTap(BuildContext context, DebugFriendTheme theme) {
    widget._bottomSheetManager.showBottomSheet(
      context,
      theme: theme,
      builder: (ctx) {
        return Provider(
          create: (_) => ConsoleManager(),
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
