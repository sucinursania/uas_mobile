import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/storage_service.dart';
import '../auth/welcome_page.dart';

/// Halaman profil pengguna yang menampilkan data akun dan pengaturan aplikasi.
/// Memungkinkan pengguna melihat dan mengubah profil, mengatur tema, melihat riwayat pesanan, dan logout.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// Controller untuk input nama lengkap profil.
  final TextEditingController nameController = TextEditingController();

  /// Controller untuk input nomor telepon profil.
  final TextEditingController phoneController = TextEditingController();

  /// Layanan autentikasi untuk mengambil dan memperbarui profil pengguna.
  final AuthService _authService = AuthService();

  /// Menandakan apakah data profil sedang dimuat.
  bool isLoading = true;

  /// Menandakan apakah proses penyimpanan perubahan profil sedang berlangsung.
  bool isUpdating = false;

  /// Memuat data profil saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  /// Mengambil data profil pengguna dari layanan autentikasi.
  Future<void> getProfile() async {
    try {
      final data = await _authService.getProfile();

      nameController.text = data['full_name'] ?? '';
      phoneController.text = data['phone'] ?? '';
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Memperbarui data profil pengguna berdasarkan input form.
  Future<void> updateProfile() async {
    try {
      setState(() {
        isUpdating = true;
      });

      await _authService.updateProfile(
        fullName: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 46,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 28),

            SoftCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Nomor Telepon",
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isUpdating ? null : updateProfile,
                      child: isUpdating
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.4,
                              ),
                            )
                          : const Text("Update Profil"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SoftCard(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("Aktifkan tema gelap"),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await StorageService.removeToken();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomePage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
