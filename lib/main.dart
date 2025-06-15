import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uploadit/auth/auth_gate.dart';
import 'package:uploadit/pages/downloadbycode_page.dart';
import 'package:uploadit/pages/downloadbyqr_page.dart';
import 'package:uploadit/pages/home_page.dart';
import 'package:uploadit/pages/login_page.dart';
import 'package:uploadit/pages/mydownloads_page.dart';
import 'package:uploadit/pages/myuploads_page.dart';
import 'package:uploadit/pages/register_page.dart';
import 'package:uploadit/pages/upload_page.dart';
import 'package:uploadit/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      routes: {
        // "/": (context) => HomePage(),
        Routes.loginRoute: (context) => LoginPage(),
        Routes.homeRoute: (context) => HomePage(),
        Routes.registerRoute: (context) => RegisterPage(),
        Routes.uploadRoute: (context) => UploadPage(),
        Routes.downloadByCodeRoute: (context) => DownloadByCodePage(),
        Routes.downloadByQRRoute: (context) => DownloadByQRPage(),
        Routes.myUploadsRoute: (context) => MyUploadsPage(),
        Routes.myDownloadsRoute: (context) => MyDownloadsPage(),
      },
    );
  }
}
