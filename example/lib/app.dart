import 'dart:html';

import 'package:example/pages/home_page.dart';
import 'package:example/util/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mono_kit/mono_kit.dart';

import 'router.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);
  static const title = 'adaptive_dialog Demo';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final platform = ref.watch(
      adaptiveStyleNotifier.select((s) => s.platform),
    );
    return MaterialApp.router(
      title: title,
      theme: lightTheme().copyWith(platform: platform).fixFontFamily(),
      darkTheme: darkTheme().copyWith(platform: platform).fixFontFamily(),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

extension on ThemeData {
  ThemeData fixFontFamily() {
    if (!kIsWeb) {
      return this;
    }
    // TODO(mono): 隔離するか、Universal系のパッケージで解決できればそうする
    final userAgent = window.navigator.userAgent;
    logger.info('userAgent: $userAgent');
    if (!userAgent.contains('OS 15_')) {
      return this;
    }
    const fontFamily = '-apple-system';
    return copyWith(
      textTheme: textTheme.apply(fontFamily: fontFamily),
      primaryTextTheme: primaryTextTheme.apply(fontFamily: fontFamily),
      // accentTextTheme: accentTextTheme.apply(fontFamily: fontFamily),
    );
  }
}
