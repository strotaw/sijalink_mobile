import '../bloc/genie_acs_cubit.dart';

/// Kontrak data perangkat GenieACS.
abstract class GenieAcsRepository {
  Future<List<AcsDevice>> fetchDevices();
}

class DummyGenieAcsRepository implements GenieAcsRepository {
  @override
  Future<List<AcsDevice>> fetchDevices() async => const [
        AcsDevice('ZTE-F609-8821', 'ZTE F609', 'Budi Santoso', true),
        AcsDevice('HUAWEI-8145-1102', 'Huawei HG8145V5', 'Siti Aminah', true),
        AcsDevice('ZTE-F609-7734', 'ZTE F609', 'Andi Pratama', false),
        AcsDevice('FIBERHOME-5520', 'Fiberhome HG6243C', 'Dewi Lestari', true),
      ];
}
