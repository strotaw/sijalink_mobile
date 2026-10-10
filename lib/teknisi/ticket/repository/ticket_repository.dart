import '../bloc/ticket_cubit.dart';

/// Kontrak data tiket. Lihat [SpkRepository] untuk pola ganti
/// ke backend (`ApiTicketRepository` + inject ke `TicketCubit`).
abstract class TicketRepository {
  Future<List<Ticket>> fetchTiket();
}

class DummyTicketRepository implements TicketRepository {
  @override
  Future<List<Ticket>> fetchTiket() async => const [
        Ticket('TKT-3012', 'Budi Santoso',
            'Internet lambat di jam sibuk', 'Sedang', TicketStatus.baru),
        Ticket('TKT-3011', 'Siti Aminah', 'WiFi sering putus',
            'Tinggi', TicketStatus.proses),
        Ticket('TKT-3010', 'Andi Pratama',
            'Tidak bisa konek PPPoE', 'Tinggi', TicketStatus.proses),
        Ticket('TKT-3009', 'Dewi Lestari', 'Ganti password WiFi',
            'Rendah', TicketStatus.selesai),
      ];
}
