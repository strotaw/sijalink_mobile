import '../bloc/spk_cubit.dart';

/// Kontrak data SPK. UI hanya bicara ke [SpkCubit], cubit bicara
/// ke repository ini — sehingga ganti sumber data (dummy → API)
/// tidak menyentuh UI sama sekali.
///
/// Saat backend siap: buat `ApiSpkRepository` yang memanggil
/// endpoint via `ApiClient`, lalu inject ke `SpkCubit(repository: ...)`.
abstract class SpkRepository {
  Future<List<Spk>> fetchSpk();
}

/// Implementasi lokal (dummy). Nanti data bertambah otomatis
/// karena list berasal dari sini / API, bukan hardcoded di UI.
class DummySpkRepository implements SpkRepository {
  @override
  Future<List<Spk>> fetchSpk() async => const [
        Spk('SPK-1024', 'Budi Santoso', 'Pasang Baru',
            'Jl. Merpati No. 12', SpkStatus.baru),
        Spk('SPK-1023', 'Siti Aminah', 'Gangguan Koneksi',
            'Jl. Kenanga No. 8', SpkStatus.proses),
        Spk('SPK-1022', 'Andi Pratama', 'Maintenance ODP',
            'Jl. Mawar No. 3', SpkStatus.proses),
        Spk('SPK-1021', 'Dewi Lestari', 'Migrasi Paket',
            'Jl. Anggrek No. 21', SpkStatus.selesai),
      ];
}
