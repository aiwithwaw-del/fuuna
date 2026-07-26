import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuuna/config/routes/route_names.dart';
import 'package:fuuna/features/auth/presentation/screens/splash_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/login_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/register_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fuuna/features/home/presentation/screens/home_screen.dart';
import 'package:fuuna/features/auth/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final location = state.matchedLocation;
      
      // Public routes — anyone can view challenges
      final publicRoutes = [
        RouteNames.splash,
        RouteNames.onboarding,
        RouteNames.login,
        RouteNames.register,
        RouteNames.forgotPassword,
        RouteNames.home,
        RouteNames.search,
        RouteNames.categories,
      ];
      
      final isPublicRoute = publicRoutes.contains(location) || 
          location.startsWith('/challenge/');
      
      // Auth screens logged-in users should not see
      final authRoutes = [
        RouteNames.login,
        RouteNames.register,
        RouteNames.onboarding,
        RouteNames.forgotPassword,
      ];
      
      // Not logged in + trying to access protected screen → send to login
      if (!isLoggedIn && !isPublicRoute) {
        return RouteNames.login;
      }
      
      // Logged in + on auth screen → send to home
      if (isLoggedIn && authRoutes.contains(location)) {
        return RouteNames.home;
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.emailVerification,
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.challengeDetails,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Challenge Details')),
        ),
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Search')),
        ),
      ),
      GoRoute(
        path: RouteNames.categories,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Categories')),
        ),
      ),
    ],
  );
});