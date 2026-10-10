import '../bloc/notification_cubit.dart';

/// Kontrak data notifikasi SPK/tiket.
abstract class NotificationRepository {
  Future<List<AppNotif>> fetchNotifikasi();
}

class DummyNotificationRepository
    implements NotificationRepository {
  @override
  Future<List<AppNotif>> fetchNotifikasi() async => [
        AppNotif(
          id: 'n1',
          title: 'SPK Baru: SPK-1024',
          body:
              'Pasang Baru untuk Budi Santoso — Jl. Merpati No. 12',
          spkNo: 'SPK-1024',
          type: NotifType.spkBaru,
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 1)),
        ),
        AppNotif(
          id: 'n2',
          title: 'SPK Diproses: SPK-1023',
          body:
              'Gangguan Koneksi Siti Aminah sedang dikerjakan',
          spkNo: 'SPK-1023',
          type: NotifType.spkProses,
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 3)),
          isRead: true,
        ),
        AppNotif(
          id: 'n3',
          title: 'SPK Selesai: SPK-1021',
          body:
              'Migrasi Paket Dewi Lestari telah selesai',
          spkNo: 'SPK-1021',
          type: NotifType.spkSelesai,
          createdAt: DateTime.now()
              .subtract(const Duration(days: 1)),
          isRead: true,
        ),
      ];
}
