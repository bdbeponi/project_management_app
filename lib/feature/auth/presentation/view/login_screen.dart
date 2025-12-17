import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/app/constants/text_font_style.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/app/router/config/route_extention.dart';
import 'package:project_management/feature/auth/presentation/view_model/auth_vm.dart';
import 'package:project_management/gen/assets.gen.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:project_management/shared/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await vm.login();

    if (!mounted) return;

    if (success) {
      // Navigation logic here
      // Navigator.of(context).pushReplacement(
      //   PageRouteBuilder(
      //     pageBuilder: (context, _, __) => const DashboardScreen(),
      //     transitionsBuilder: (_, animation, __, child) =>
      //         FadeTransition(opacity: animation, child: child),
      //     transitionDuration: const Duration(milliseconds: 400),
      //   ),
      // );
      nav.toNavigation();
    } else {
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invalid credentials. Please try again.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Consumer2<ThemeProvider, AuthViewModel>(
        builder: (context, themeProvider, vm, _) {
          final isDark = themeProvider.isDarkMode;

          return Scaffold(
            backgroundColor: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: _ThemeToggle(
                            themeProvider: themeProvider,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _Logo(),
                        const SizedBox(height: 48),
                        _LoginCard(
                          formKey: _formKey,
                          vm: vm,
                          isDark: isDark,
                          onLogin: () => _handleLogin(vm),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Extracted Theme Toggle Widget
class _ThemeToggle extends StatelessWidget {
  final ThemeProvider themeProvider;
  final bool isDark;

  const _ThemeToggle({required this.themeProvider, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        themeProvider.toggleTheme();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
            );
          },
          child: Icon(
            isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
            key: ValueKey<bool>(isDark),
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            size: 28,
          ),
        ),
      ),
    );
  }
}

// Extracted Logo Widget
class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Image.asset(Assets.images.fullAppIcon.path, fit: BoxFit.contain),
      ),
    );
  }
}

// Extracted Login Card Widget
class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AuthViewModel vm;
  final bool isDark;
  final VoidCallback onLogin;

  const _LoginCard({
    required this.formKey,
    required this.vm,
    required this.isDark,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDark ? 4 : 2,
      color: isDark ? AppColors.cardDark : AppColors.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildEmailField(vm.emailController),
              const SizedBox(height: 20),
              _buildPasswordField(vm.passwordController),
              const SizedBox(height: 8),
              _buildRememberMe(),
              const SizedBox(height: 28),
              _buildSignInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please enter your details to sign in.',
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(TextEditingController cnt) {
    return CustomTextFieldWidget(
      controller: cnt,
      borderColor: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
      fillColor: isDark
          ? AppColors.inputBackgroundDark
          : AppColors.inputBackground,
      hintText: "Email",
      hintStyle: TextStyle(
        color: isDark ? AppColors.textHintDark : AppColors.textHint,
      ),
      style: TextStyle(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController cnt) {
    return CustomTextFieldWidget(
      controller: cnt,
      borderColor: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
      fillColor: isDark
          ? AppColors.inputBackgroundDark
          : AppColors.inputBackground,
      hintText: "Password",
      hintStyle: TextStyle(
        color: isDark ? AppColors.textHintDark : AppColors.textHint,
      ),
      style: TextStyle(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: vm.rememberMe,
          onChanged: (value) {
            if (value != null) {
              vm.toggleRememberMe(value);
            }
          },
        ),
        Text(
          "Remember me",
          style: TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: vm.isLoading ? null : onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? AppColors.buttonPrimary
              : AppColors.buttonSecondary,
          disabledBackgroundColor:
              (isDark ? AppColors.buttonPrimary : AppColors.buttonSecondary)
                  .withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: vm.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
      ),
    );
  }
}
