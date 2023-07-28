import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/auth/auth.dart';
import 'package:movie_app/features/auth/presentation/widgets/social_auth_section.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final ValueNotifier<bool> _showPassword;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _showPassword = ValueNotifier(false);
    super.initState();
  }

  Future<void> signup() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(signupControllerProvider.notifier).signupWithCreds(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signupState = ref.watch(signupControllerProvider);
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(signupControllerProvider, (oldState, newState) async {
      if (newState is BaseError) {
        if (!mounted) return;
        await context.showSnackbar(newState.failure.reason, isError: true);
      }
      if (newState is BaseSuccess<UserModel>) {
        if (!mounted) return;
        await context.showSnackbar('Welcome ${newState.data?.email}');
      }
    });
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            leadingWidth: 100,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Image.asset(
                AppAssets.appLogo,
                fit: BoxFit.contain,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(skippedProvider.notifier).state = true;
                  context.go(RoutePaths.latestMovies.path);
                },
                child: Text(
                  'Skip'.hardcoded,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ],
          ),
          body: AbsorbPointer(
            absorbing: signupState is BaseLoading || loginState is BaseLoading,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              splashColor: Theme.of(context).coreTransparent,
              focusColor: Theme.of(context).coreTransparent,
              highlightColor: Theme.of(context).coreTransparent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height / 10),
                            Text(
                              'Hello there,'.hardcoded,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Sign up to continue'.hardcoded,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 30),
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Email'.hardcoded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: Validators.emailValidator,
                            ),
                            const SizedBox(height: 10),
                            ValueListenableBuilder<bool>(
                              valueListenable: _showPassword,
                              builder: (context, value, child) {
                                return CustomTextField(
                                  obscureText: !value,
                                  controller: _passwordController,
                                  hintText: 'Password'.hardcoded,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  validator: Validators.passwordValidator,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _showPassword.value = !value;
                                    },
                                    child: Icon(
                                      value
                                          ? Ionicons.eye_off_outline
                                          : Ionicons.eye_outline,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: CustomButton(
                                title: 'Sign up'.hardcoded,
                                loading: signupState is BaseLoading ||
                                    loginState is BaseLoading,
                                onTap: signup,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(
                                  flex: 2,
                                ),
                                const Expanded(
                                  child: Divider(thickness: 1.5),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'OR'.hardcoded,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(thickness: 1.5),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            const SocialAuthSection(),
                          ],
                        ),
                      ),
                    ),
                    if (!isKeyboardVisible) ...[
                      EntranceFader(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? '.hardcoded,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.pop(),
                                text: 'Sign in'.hardcoded,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Theme.of(context).coreBlue,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
