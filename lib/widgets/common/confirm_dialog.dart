import 'package:flutter/material.dart';

import '../../theme/app.dart';

/// Menampilkan dialog konfirmasi sederhana dengan tombol setuju dan batal.
Future<bool?> showConfirmDialog({
  /// Konteks yang digunakan untuk menampilkan dialog.
  required BuildContext context,

  /// Judul dialog konfirmasi.
  required String title,

  /// Pesan penjelasan yang ditampilkan di dalam dialog.
  required String message,

  /// Teks tombol konfirmasi.
  String confirmText = "Ya",

  /// Teks tombol pembatalan.
  String cancelText = "Batal",
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: AppTheme.heading,
        ),
        content: Text(
          message,
          style: AppTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}