import '../bloc/attendance_cubit.dart';

/// Kontrak data riwayat presensi.
abstract class AttendanceRepository {
  Future<List<PresensiRecord>> fetchRiwayat();
}

class DummyAttendanceRepository implements AttendanceRepository {
  @override
  Future<List<PresensiRecord>> fetchRiwayat() async => [
        PresensiRecord(
            tanggal: DateTime(2026, 9, 29),
            jenis: PresensiJenis.checkIn,
            jam: '07:58'),
        PresensiRecord(
            tanggal: DateTime(2026, 9, 26),
            jenis: PresensiJenis.checkIn,
            jam: '08:05'),
        PresensiRecord(
            tanggal: DateTime(2026, 9, 26),
            jenis: PresensiJenis.checkOut,
            jam: '17:02'),
      ];
}
