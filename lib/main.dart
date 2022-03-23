import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:live_analysis_tool/pages/add_project_page.dart';
import 'package:live_analysis_tool/pages/record_project_page.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:live_analysis_tool/pages/dashboard_page.dart';
import 'package:live_analysis_tool/pages/login_page.dart';
import 'package:live_analysis_tool/pages/splash_page.dart';

import 'dto/project.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.debug;
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'],
    anonKey: dotenv.env['SUPABASE_ANON_KEY'],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Supabase Flutter',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Colors.green,
            ),
          ),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (_) => const SplashPage(),
          '/login': (_) => const LoginPage(),
          '/dashboard': (_) => const DashboardPage(),
          '/dashboard/addProject': (_) => const AddProjectPage(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ('/dashboard/recording'):
              Project project = settings.arguments as Project;
              return MaterialPageRoute(builder: (context) {
                return RecordProjectPage(project: project);
              });
          }
        });
  }
}
