import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:our_voice/providers/artProvider.dart';
import 'package:our_voice/providers/commentsProvider.dart';
import 'package:our_voice/providers/ownerProvider.dart';
import 'package:our_voice/providers/userprovider.dart';
import 'package:our_voice/screens/QRViewExample.dart';
import 'package:our_voice/screens/artCreation/addArtPage.dart';
import 'package:our_voice/screens/artCreation/artCreation.dart';
import 'package:our_voice/screens/auth/signin_screen.dart';
import 'package:our_voice/screens/auth/signup_screen.dart';
import 'package:our_voice/screens/main/authgate.dart';
import 'package:our_voice/screens/homepage.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => UserProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ArtProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => CommentsProvider(),
            ),
            
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Our Voice',
            initialRoute: AuthGate.id,
            routes: {
              AuthGate.id: (context) => const AuthGate(),
              SigninPage.id: (context) => const SigninPage(),
              SignupPage.id: (context) => const SignupPage(),
              MainPage.id: (context) => const MainPage(),
              HomePage.id: (context) => const HomePage(),
              AddArtPage.id: (context) => const AddArtPage(),
              QRViewExample.id: (context) => const QRViewExample(),
              ArtCreationScreen.id: (context) => const ArtCreationScreen(),
            },
            theme: ThemeData(
              useMaterial3: true,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF6006EE),
                    style: BorderStyle.solid,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF6006EE),
                    style: BorderStyle.solid,
                  ),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(
                  color: Colors.black38,
                ),
                hintStyle: TextStyle(
                  color: const Color(0xFF6006EE).withOpacity(0.4),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(10),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF6006EE)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
              ),
              primaryColor: const Color(0xFF6006EE),
              canvasColor: Colors.white,
              appBarTheme: const AppBarTheme(
                surfaceTintColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
