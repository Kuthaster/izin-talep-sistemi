import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Colors matching your HTML/CSS palette
    const Color purpleBg = Color(0xFFEEEDFE);
    const Color purpleDark = Color(0xFF26215C);
    const Color purpleMedium = Color(0xFF3C3489);
    const Color circleAccent1 = Color(0xFF7F77DD);
    const Color circleAccent2 = Color(0xFFAFA9EC);
    const Color circleAccent3 = Color(0xFFCECBF6);
    const Color surface2 = Color(0xFFF8F9FA);
    const Color textColorSecondary = Color(0xFF6C757D);
    const Color borderColor = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Panel: Brand Banner (50% Width, 100% Height)
          Expanded(
            child: Container(
              color: purpleBg,
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: purpleMedium,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: purpleBg,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  // Main Text
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'İzin sistemine hoş geldin',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: purpleDark,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Taleplerini oluştur, takip et, onayla.',
                        style: TextStyle(fontSize: 16, color: purpleMedium),
                      ),
                    ],
                  ),

                  // Accent Dots
                  const Row(
                    children: [
                      CircleAvatar(radius: 12, backgroundColor: circleAccent1),
                      SizedBox(width: 8),
                      CircleAvatar(radius: 12, backgroundColor: circleAccent2),
                      SizedBox(width: 8),
                      CircleAvatar(radius: 12, backgroundColor: circleAccent3),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Right Panel: Form Area (50% Width, 100% Height)
          Expanded(
            child: Container(
              color: surface2,
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 32.0,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Giriş yap',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColorSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'adsoyad@yourcompany.com',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: borderColor,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Şifre',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColorSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Şifrenizi girin',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: borderColor,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: _obscurePassword
                                  ? Icon(Icons.visibility_off_sharp)
                                  : Icon(Icons.visibility_sharp),
                              tooltip: 'Şifre görünürlüğünü aç/kapa',
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () {
                                    // Trigger login logic via riverpod
                                    ref
                                        .read(authProvider.notifier)
                                        .login(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purpleMedium,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Giriş yap',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
