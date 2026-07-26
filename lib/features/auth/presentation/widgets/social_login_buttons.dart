import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuuna/core/widgets/custom_button.dart';
import 'package:fuuna/features/auth/presentation/providers/auth_provider.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomButton(
          text: 'Continue with Google',
          icon: Icons.g_mobiledata,
          isOutlined: true,
          onPressed: () {
            ref.read(authNotifierProvider.notifier).signInWithGoogle();
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Continue with Apple',
          icon: Icons.apple,
          isOutlined: true,
          onPressed: () {
            // TODO: Implement Apple Sign In
          },
        ),
      ],
    );
  }
}