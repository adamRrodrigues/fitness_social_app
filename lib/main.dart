import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_social_app/firebase_options.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/routing/page_router.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/services/drafts.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/shared_preferences.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/themes/dark_theme.dart';
import 'package:fitness_social_app/themes/light_theme.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider((ref) => FirebaseAuth.instance.currentUser);
final dayProvider = Provider((ref) => Day());
final userServicesProvider = Provider((ref) => UserServices());
final authProvider = Provider((ref) => Auth());
final genericPostServicesProvider = Provider((ref) => GenericPostServices());
final feedServicesProvider = Provider((ref) => FeedServices());
final utilProvider = Provider((ref) => Utils());
final draftProvider = Provider((ref) => WorkoutDraft());
final mealDraftProvider = Provider((ref) => MealDraft());
final routineProvider = Provider((ref) => Routine());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      color: Theme.of(context).colorScheme.background,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      //
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
    );
  }
}
