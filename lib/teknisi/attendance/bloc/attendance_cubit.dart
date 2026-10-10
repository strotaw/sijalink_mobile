import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/attendance_repository.dart';

// ---------- Models ----------
class KehadiranHarian extends Equatable {
  final String hari;
  final bool hadir;
  const KehadiranHarian(this.hari, this.hadir);
  @override
  List<Object> get props => [hari, hadir];
}

enum PresensiJenis { checkIn, checkOut, izin }

class PresensiRecord extends Equatable {
  final DateTime tanggal;
  final PresensiJenis jenis;
  final String jam;
  final String? keterangan;
  final String? fotoPath;

  const PresensiRecord({
    required this.tanggal,
    required this.jenis,
    required this.jam,
    this.keterangan,
    this.fotoPath,
  });

  factory PresensiRecord.fromJson(Map<String, dynamic> json) =>
      PresensiRecord(
        tanggal: DateTime.tryParse(
                json['tanggal'] as String? ?? '') ??
            DateTime.now(),
        jenis: PresensiJenis.values.firstWhere(
          (e) =>
              e.name ==
              (json['jenis'] as String? ?? 'checkIn'),
          orElse: () => PresensiJenis.checkIn,
        ),
        jam: json['jam'] as String? ?? '',
        keterangan: json['keterangan'] as String?,
        fotoPath: json['fotoPath'] as String?,
      );

  /// Payload JSON untuk database backend. File foto dikirim
  /// terpisah (multipart) lalu `fotoPath` diisi URL hasilnya.
  Map<String, dynamic> toJson() => {
        'tanggal': tanggal.toIso8601String(),
        'jenis': jenis.name,
        'jam': jam,
        if (keterangan != null) 'keterangan': keterangan,
        if (fotoPath != null) 'fotoPath': fotoPath,
      };

  @override
  List<Object?> get props => [tanggal, jenis, jam];
}

// ---------- State ----------
class AttendanceState extends Equatable {
  final bool sudahCheckIn;
  final bool sudahCheckOut;
  final String? jamMasuk;
  final String? jamKeluar;
  final String? fotoMasuk;
  final String? fotoKeluar;
  final String? izinHariIni;
  final String? izinTipe;
  final List<PresensiRecord> riwayat;
  final List<KehadiranHarian> mingguIni;
  final int totalHadirBulanIni;
  final int totalTerlambat;
  final int totalIzin;

  const AttendanceState({
    this.sudahCheckIn = false,
    this.sudahCheckOut = false,
    this.jamMasuk,
    this.jamKeluar,
    this.fotoMasuk,
    this.fotoKeluar,
    this.izinHariIni,
    this.izinTipe,
    this.riwayat = const [],
    this.mingguIni = const [
      KehadiranHarian('S', true),
      KehadiranHarian('S', true),
      KehadiranHarian('R', true),
      KehadiranHarian('K', true),
      KehadiranHarian('J', false),
      KehadiranHarian('S', true),
      KehadiranHarian('M', true),
    ],
    this.totalHadirBulanIni = 22,
    this.totalTerlambat = 2,
    this.totalIzin = 1,
  });

  AttendanceState copyWith({
    bool? sudahCheckIn,
    bool? sudahCheckOut,
    String? jamMasuk,
    String? jamKeluar,
    String? fotoMasuk,
    String? fotoKeluar,
    String? izinHariIni,
    String? izinTipe,
    List<PresensiRecord>? riwayat,
    int? totalHadirBulanIni,
    int? totalIzin,
  }) =>
      AttendanceState(
        sudahCheckIn: sudahCheckIn ?? this.sudahCheckIn,
        sudahCheckOut: sudahCheckOut ?? this.sudahCheckOut,
        jamMasuk: jamMasuk ?? this.jamMasuk,
        jamKeluar: jamKeluar ?? this.jamKeluar,
        fotoMasuk: fotoMasuk ?? this.fotoMasuk,
        fotoKeluar: fotoKeluar ?? this.fotoKeluar,
        izinHariIni: izinHariIni ?? this.izinHariIni,
        izinTipe: izinTipe ?? this.izinTipe,
        riwayat: riwayat ?? this.riwayat,
        mingguIni: mingguIni,
        totalHadirBulanIni:
            totalHadirBulanIni ?? this.totalHadirBulanIni,
        totalTerlambat: totalTerlambat,
        totalIzin: totalIzin ?? this.totalIzin,
      );

  int get hadirMingguIni =>
      mingguIni.where((h) => h.hadir).length;

  int get izinBulanIni => riwayat
      .where((r) => r.jenis == PresensiJenis.izin)
      .length;

  @override
  List<Object?> get props => [
        sudahCheckIn,
        sudahCheckOut,
        jamMasuk,
        jamKeluar,
        fotoMasuk,
        fotoKeluar,
        izinHariIni,
        izinTipe,
        riwayat,
        totalHadirBulanIni,
        totalIzin,
      ];
}

// ---------- Cubit ----------
class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepository _repository;
  AttendanceCubit({AttendanceRepository? repository})
      : _repository = repository ?? DummyAttendanceRepository(),
        super(const AttendanceState()) {
    muatUlang();
  }

  Future<void> muatUlang() async {
    try {
      final riwayat = await _repository.fetchRiwayat();
      if (isClosed) return;
      emit(state.copyWith(riwayat: riwayat));
    } catch (_) {}
  }

  static String jamSekarang() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void checkIn(String fotoPath) {
    final jam = jamSekarang();
    emit(state.copyWith(
      sudahCheckIn: true,
      jamMasuk: jam,
      fotoMasuk: fotoPath,
      riwayat: [
        PresensiRecord(
            tanggal: DateTime.now(),
            jenis: PresensiJenis.checkIn,
            jam: jam,
            fotoPath: fotoPath),
        ...state.riwayat,
      ],
      totalHadirBulanIni: state.totalHadirBulanIni + 1,
    ));
  }

  void checkOut(String fotoPath) {
    final jam = jamSekarang();
    emit(state.copyWith(
      sudahCheckOut: true,
      jamKeluar: jam,
      fotoKeluar: fotoPath,
      riwayat: [
        PresensiRecord(
            tanggal: DateTime.now(),
            jenis: PresensiJenis.checkOut,
            jam: jam,
            fotoPath: fotoPath),
        ...state.riwayat,
      ],
    ));
  }

  void ajukanIzin(String tipe, String keterangan) {
    final jam = jamSekarang();
    emit(state.copyWith(
      izinHariIni: '$tipe — $keterangan',
      izinTipe: tipe,
      riwayat: [
        PresensiRecord(
            tanggal: DateTime.now(),
            jenis: PresensiJenis.izin,
            jam: jam,
            keterangan: '$tipe — $keterangan'),
        ...state.riwayat,
      ],
      totalIzin: state.totalIzin + 1,
    ));
  }
}
