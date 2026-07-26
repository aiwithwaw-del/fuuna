import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fuuna/config/routes/route_names.dart';
import 'package:fuuna/features/auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuuna'),
        actions: [
          if (user == null)
            TextButton(
              onPressed: () => context.push(RouteNames.login),
              child: const Text(
                'Sign In',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department, size: 64, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(
              'Challenge Feed',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user == null 
                ? 'Browse challenges. Sign in to apply.'
                : 'Welcome back, ${user.displayName ?? user.email}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            if (user == null)
              ElevatedButton(
                onPressed: () => context.push(RouteNames.login),
                child: const Text('Sign In to Apply'),
              ),
          ],
        ),
      ),
    );
  }
}