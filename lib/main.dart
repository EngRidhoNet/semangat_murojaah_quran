import 'package:flutter/material.dart';
import 'package:my_quran/providers/audio_player_provider.dart';
import 'package:my_quran/providers/theme_provider.dart';
import 'package:my_quran/repositories/quran_repository.dart';
import 'package:my_quran/screens/home_screen.dart';
import 'package:my_quran/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ProxyProvider<ApiService, QuranRepository>(
          update: (_, apiService, __) => QuranRepository(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AudioPlayerProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Al-Quran App',
            theme: themeProvider.theme,
            debugShowCheckedModeBanner: false, // Add this line
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
