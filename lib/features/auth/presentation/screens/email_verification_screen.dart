import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fuuna/config/routes/route_names.dart';
import 'package:fuuna/features/auth/presentation/providers/auth_provider.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_unread, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              Text(
                'Verify your email',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We sent a verification link to your email. Please check your inbox and verify to continue.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authRepositoryProvider).sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email sent')),
                  );
                },
                child: const Text('Resend Email'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(RouteNames.home),
                child: const Text('I verified - Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}