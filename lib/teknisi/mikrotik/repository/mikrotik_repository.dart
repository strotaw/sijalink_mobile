import '../bloc/mikrotik_cubit.dart';

/// Kontrak data Mikrotik.
abstract class MikrotikRepository {
  Future<List<Mikrotik>> fetchMikrotik();
}

class DummyMikrotikRepository implements MikrotikRepository {
  @override
  Future<List<Mikrotik>> fetchMikrotik() async => const [
        Mikrotik('MT-Pusat', '103.147.10.1', true, 248, '12d 4h'),
        Mikrotik('MT-Cabang Timur', '103.147.10.2', true, 132, '8d 11h'),
        Mikrotik('MT-Cabang Barat', '103.147.10.3', false, 0, 'offline 2h'),
      ];
}
