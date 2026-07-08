import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Layanan untuk menampilkan notifikasi lokal di aplikasi.
/// Digunakan untuk memberi tahu pengguna saat aksi tertentu berhasil dilakukan.
class NotificationService {
  /// Plugin notifikasi lokal yang digunakan untuk mengelola pemberitahuan.
  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Menginisialisasi sistem notifikasi lokal pada perangkat.
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);

    // request permission android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Menampilkan notifikasi dengan judul dan isi pesan tertentu.
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'cart_channel',
      'Cart Notification',
      channelDescription: 'Notification from C! Mart',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      details,
    );
  }
}