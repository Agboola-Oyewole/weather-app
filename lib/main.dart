import 'package:clima_weather/data/units_data.dart';
import 'package:clima_weather/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/notification_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize();

  runApp(ChangeNotifierProvider(
    create: (context) => UnitData(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      home: const LoadingScreen(),
    ),
  ));
}
