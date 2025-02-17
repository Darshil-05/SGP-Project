import 'package:charusat_recruitment/Providers/announcement_provider.dart';
import 'package:charusat_recruitment/Providers/company_provider.dart';
import 'package:charusat_recruitment/Providers/menu_provider.dart';
import 'package:charusat_recruitment/screens/home.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/announcement_manage.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/company/company_details.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/company/company_manager.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/company/company_round.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/company/student_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../screens/welcome.dart';
import '../screens/auth/forgotpage.dart';
import '../screens/auth/otp.dart';
import '../Providers/theme_provider.dart';
import '../Providers/pie_chart_provider.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Themechange()),
        ChangeNotifierProvider(create: (_) => PieChartProvider()),
        ChangeNotifierProvider(create: (_)=> MenuProvider()),
        ChangeNotifierProvider(
            create: (_) => AnnouncementProvider()), // Add PieChartProvider here
            
      ],
      child: Builder(
        builder: (context) {
          final themechanger = Provider.of<Themechange>(context);
          return MaterialApp(
            routes: {
              '/home': (context) => const Home(), // Change Home to HomeApp
              '/welcome': (context) => const Welcome(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/forgot': (context) => const ForgotPage(),
              '/otp': (context) => const OtpPage(),
              '/companydetails': (context) => const CompanyDetailsPage(),
              '/announcement': (context) => const AnnouncementManagement(),
              '/companymanager': (context) => const CompanyManager(),
              '/round': (context) => const RoundManager(),
              '/studentlist': (context) => const StudentListManager(),
            },
            debugShowCheckedModeBanner: false,
            title: 'Charusat Placement App',
            themeMode: themechanger.themeMode,
            theme: ThemeManager.lightmode,
            darkTheme: ThemeManager.darkmode,
            home: const Home(), // Change to Home for skip login and starting from welcome
          );
        },
      ),
    );
  }
}
