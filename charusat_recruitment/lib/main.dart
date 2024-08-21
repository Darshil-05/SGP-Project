import 'package:charusat_recruitment/screens/home.dart';

import '../screens/screens_after_auth/customtabbar.dart';
import '../screens/welcome.dart';

import '../screens/auth/forgotpage.dart';
import '../screens/auth/otp.dart';

import '../Providers/theme_provider.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp( const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final themeChanger = Provider.of<Themechange>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Themechange()),
      ],
      child: Builder(builder: (context) {
        final themechanger = Provider.of<Themechange>(context);
        return MaterialApp(
          routes: {
            '/home' :(context) => const Home(),// currently working route
            '/welcome' :(context) => const Welcome(),
            '/login' :(context) => const LoginPage(),
            '/register' :(context) => const RegisterPage(),
            '/forgot' :(context) => const ForgotPage(),
            '/otp' :(context) => const OtpPage(),
          },
          // initialRoute: '/welcome',
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          themeMode: themechanger.themeMode,
          theme: ThemeManager.lightmode,
          darkTheme: ThemeManager.darkmode,
          home: const Home(),
        );
      }),
    );
  }
}
