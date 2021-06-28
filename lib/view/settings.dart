import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtime/core/cubits/preference_cubit.dart';
import 'package:vtime/core/utils/widgets.dart';
import 'package:vtime/view/widgets/appbars.dart';

class Settings extends VTStatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends VTState<Settings> {
  final langSegments = const <int, Widget>{
    0: Text('English'),
    1: Text('Türkçe'),
    2: Text('Русский'),
    3: Text('ქართული')
  };

  int themeSegmentedValue = 0;
  int langSegmentedValue = 0;

  dynamic detectTheme() {
    switch (BlocProvider.of<PreferenceCubit>(context).state.themeName) {
      case 'default':
        return themeSegmentedValue = 0;
      case 'dark':
        return themeSegmentedValue = 1;
    }
    return 0;
  }

  dynamic detectLang() {
    switch (BlocProvider.of<PreferenceCubit>(context).state.langCode) {
      case 'en':
        return langSegmentedValue = 0;
      case 'tr':
        return langSegmentedValue = 1;
      case 'ru':
        return langSegmentedValue = 2;
      case 'ka':
        return langSegmentedValue = 3;
    }
    return 0;
  }

  @override
  void initState() {
    detectTheme();
    detectLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeSegments = <int, Widget>{
      0: Text(vt.intl.of(context)!.fmt('prefs.appearance.light')),
      1: Text(vt.intl.of(context)!.fmt('prefs.appearance.dark'))
    };
    return Scaffold(
      appBar: TransparentAppBar(
        titleWidget: Text(vt.intl.of(context)!.fmt('prefs.settings')),
        onLeadingTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              themeSelecting(themeSegments),
              const SizedBox(height: 50),
              langSelecting(),
            ],
          ),
        ),
      ),
    );
  }

  Column themeSelecting(themeSegments) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            vt.intl.of(context)!.fmt('prefs.appearance'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 300,
          child: CupertinoSlidingSegmentedControl(
            padding: const EdgeInsets.all(0),
            groupValue: themeSegmentedValue,
            children: themeSegments,
            onValueChanged: (dynamic i) {
              if (i == 0) {
                BlocProvider.of<PreferenceCubit>(context)
                    .changeTheme('default');
              } else {
                BlocProvider.of<PreferenceCubit>(context).changeTheme('dark');
              }
              setState(() => themeSegmentedValue = i);
            },
          ),
        ),
      ],
    );
  }

  Column langSelecting() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            vt.intl.of(context)!.fmt('prefs.lang'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 500,
          child: CupertinoSlidingSegmentedControl(
            padding: const EdgeInsets.all(0),
            groupValue: langSegmentedValue,
            children: langSegments,
            onValueChanged: (dynamic i) {
              changeLanguage(i);
              setState(() => langSegmentedValue = i);
            },
          ),
        ),
      ],
    );
  }

  void changeLanguage(int i) {
    var args = {
      0: () => BlocProvider.of<PreferenceCubit>(context).changeLang('en'),
      1: () => BlocProvider.of<PreferenceCubit>(context).changeLang('tr'),
      2: () => BlocProvider.of<PreferenceCubit>(context).changeLang('ru'),
      3: () => BlocProvider.of<PreferenceCubit>(context).changeLang('ka'),
    };
    args[i]!.call();
  }
}
