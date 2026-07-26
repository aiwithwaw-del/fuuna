import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuuna/config/routes/route_names.dart';
import 'package:fuuna/features/auth/presentation/providers/auth_provider.dart';
import 'package:fuuna/features/auth/presentation/screens/splash_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/login_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/register_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fuuna/features/auth/presentation/screens/forgot_password_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = authState.valueOrNull;
      final isLoggedIn = user != null;
      final isAuthRoute = [
        RouteNames.login,
        RouteNames.register,
        RouteNames.onboarding,
        RouteNames.forgotPassword,
      ].contains(state.matchedLocation);

      if (!isLoggedIn && !isAuthRoute && state.matchedLocation != RouteNames.splash) {
        return RouteNames.login;
      }

      if (isLoggedIn && isAuthRoute) {
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
    ],
  );
});