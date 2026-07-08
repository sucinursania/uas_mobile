import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_textfield.dart';
import '../../widgets/common/page_header.dart';

import '../home/main_page.dart';
import 'register_page.dart';

/// Halaman login untuk pengguna yang sudah memiliki akun.
/// Menampilkan form email, password, dan tombol masuk serta opsi untuk berpindah ke halaman pendaftaran.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Kunci form untuk validasi input login.
  final _formKey = GlobalKey<FormState>();

  /// Controller untuk input email.
  final emailController = TextEditingController();

  /// Controller untuk input password.
  final passwordController = TextEditingController();

  /// Layanan autentikasi yang digunakan untuk proses login.
  final AuthService _authService = AuthService();

  /// Menentukan apakah password ditampilkan atau disembunyikan.
  bool obscurePassword = true;

  /// Menandakan apakah proses login sedang berlangsung.
  bool isLoading = false;

  /// Melakukan proses login pengguna dengan validasi form.
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const PageHeader(
                  title: "Masuk",
                  subtitle:
                      "Selamat datang kembali.\nSilakan login untuk melanjutkan.",
                ),

                const SizedBox(height: 36),

                const AppLabel("Email"),

                AppTextField(
                  controller: emailController,
                  hint: "Masukkan email",
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const AppLabel("Password"),

                AppTextField(
                  controller: passwordController,
                  hint: "Masukkan password",
                  icon: Icons.lock_outline_rounded,
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Forgot Password
                    },
                    child: const Text("Lupa Password?"),
                  ),
                ),

                const SizedBox(height: 20),

                AppButton(
                  text: "Login",
                  loading: isLoading,
                  onPressed: login,
                ),

                const SizedBox(height: 28),

                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        "Belum punya akun?",
                        style: AppTheme.body.copyWith(
                          color: AppTheme.subtitleColor(context),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text("Daftar"),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}