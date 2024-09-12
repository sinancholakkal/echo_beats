

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<String> themeNoti =ValueNotifier<String>('dark');

Future<void> addThem(String result)async{
  final openedBox = await Hive.openBox<String>("theme_box");
  await openedBox.clear();
  await openedBox.put("theme",result);
  themeNoti.value =result;
  themeNoti.notifyListeners();
}

Future<void>getTheme()async{
  final openedBox = await Hive.openBox<String>("theme_box");
  themeNoti.value =openedBox.get('theme',defaultValue: 'dark')!;
  themeNoti.notifyListeners();
}