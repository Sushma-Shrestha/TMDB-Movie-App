import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/auth/auth.dart';

class SocialAuthSection extends ConsumerWidget {
  const SocialAuthSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialAuthState = ref.watch(socialLoginControllerProvider);
    ref.listen(
      socialLoginControllerProvider,
      (oldState, newState) {
        if (newState is BaseError) {
          context.showSnackbar(newState.failure.reason, isError: true);
        }
        if (newState is BaseSuccess<UserModel>) {
          context.showSnackbar('Welcome ${newState.data?.email}');
        }
      },
    );
    return AbsorbPointer(
      absorbing: socialAuthState is BaseLoading,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              ref
                  .read(socialLoginControllerProvider.notifier)
                  .loginWithSocialAuth(
                    socialAuthType: SocialAuthType.google,
                  );
            },
            child: const SocialLoginButton(asset: AppAssets.googleLogo),
          ),
        ],
      ),
    );
  }
}
