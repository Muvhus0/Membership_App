import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/membership_provider.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/home/main_screen.dart';
import 'services/data_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*load persisted data before starting the application
   so the authentication state is ready at launch.*/
  final storageService = await StorageService.getInstance();
  final dataService = DataService();

  final memberships = await dataService.loadMemberships();
  final users = await dataService.seedInitialUsersIfNeeded(storageService);

  final authProvider = AuthProvider(storageService)..initialize(users);
  final membershipProvider = MembershipProvider()..initialize(memberships);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: membershipProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Membership App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (authProvider.isAuthenticated) {
            return const MainScreen();
          }

          return const SignInScreen();
        },
      ),
    );
  }
}
