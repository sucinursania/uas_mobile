import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app.dart';

import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_textfield.dart';
import '../../widgets/common/page_header.dart';

/// Halaman pendaftaran untuk pengguna baru.
/// Menyediakan form untuk mengisi nama, email, dan password sebelum membuat akun.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// Kunci form untuk validasi input pendaftaran.
  final _formKey = GlobalKey<FormState>();

  /// Controller untuk input nama lengkap.
  final nameController = TextEditingController();

  /// Controller untuk input email.
  final emailController = TextEditingController();

  /// Controller untuk input password.
  final passwordController = TextEditingController();

  /// Layanan autentikasi yang digunakan untuk proses pendaftaran.
  final AuthService authService = AuthService();

  /// Menentukan apakah password ditampilkan atau disembunyikan.
  bool obscurePassword = true;

  /// Menandakan apakah proses pendaftaran sedang berlangsung.
  bool isLoading = false;

  /// Melakukan proses pendaftaran pengguna baru.
  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      await authService.register(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register berhasil! Silakan login."),
        ),
      );

      Navigator.pop(context);
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
    nameController.dispose();
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
                  title: "Buat Akun",
                  subtitle:
                      "Daftar sekarang dan mulai pengalaman belanja terbaik.",
                ),

                const SizedBox(height: 36),

                const AppLabel("Nama Lengkap"),

                AppTextField(
                  controller: nameController,
                  hint: "Masukkan nama lengkap",
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 22),

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

                    if (!value.contains('@')) {
                      return "Email tidak valid";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

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

                    if (value.length < 6) {
                      return "Minimal 6 karakter";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 32),

                AppButton(
                  text: "Daftar",
                  loading: isLoading,
                  onPressed: register,
                ),

                const SizedBox(height: 28),

                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        "Sudah punya akun?",
                        style: AppTheme.body.copyWith(
                          color: AppTheme.subtitleColor(context),
                        ),
                      ),

                      TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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