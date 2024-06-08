import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/service/comment_service.dart';
import 'package:tube_vibe/service/user_service.dart';
import 'package:tube_vibe/service/video_service.dart';
import 'package:tube_vibe/firebase_options.dart';
import 'package:tube_vibe/provider/comment_provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/screens/login/login_screen.dart';
import 'package:tube_vibe/view/screens/main_screen.dart';
import 'package:tube_vibe/view/screens/signup/signup_screen.dart';
import 'package:tube_vibe/view/screens/splash/splash_screen.dart';
import 'package:tube_vibe/view/screens/videos/videos_screen.dart';
import 'package:tube_vibe/view/screens/watchlist/watch_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => VideoUploadProvider(VideoService())),
        ChangeNotifierProvider(create: (_) => UserProvider(UserService())),
        ChangeNotifierProvider(
            create: (_) => CommentProvider(CommentService())),
      ],
      child: MaterialApp(
        title: 'TubeVibe',
        theme: ThemeData(
          scaffoldBackgroundColor: primaryBlack,
          appBarTheme: AppBarTheme(backgroundColor: primaryBlack),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          "main": (context) => const MainScreen(),
          'signup': (context) => SignupScreen(),
          'login': (context) => LoginScreen(),
          "watch-list": (context) => const WatchListScreen(),
          "videos": (context) => const VideosScreen(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}
