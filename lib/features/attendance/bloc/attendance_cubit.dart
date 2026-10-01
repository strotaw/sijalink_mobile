import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------- Models ----------
class KehadiranHarian extends Equatable {
  final String hari;
  final bool hadir;
  const KehadiranHarian(this.hari, this.hadir);
  @override
  List<Object> get props => [hari, hadir];
}

// ---------- State ----------
class AttendanceState extends Equatable {
  final bool sudahCheckIn;
  final bool sudahCheckOut;
  final String? jamMasuk;
  final String? jamKeluar;
  final List<KehadiranHarian> mingguIni;
  final int totalHadirBulanIni;
  final int totalTerlambat;

  const AttendanceState({
    this.sudahCheckIn = false,
    this.sudahCheckOut = false,
    this.jamMasuk,
    this.jamKeluar,
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
  });

  AttendanceState copyWith({
    bool? sudahCheckIn,
    bool? sudahCheckOut,
    String? jamMasuk,
    String? jamKeluar,
  }) =>
      AttendanceState(
        sudahCheckIn: sudahCheckIn ?? this.sudahCheckIn,
        sudahCheckOut: sudahCheckOut ?? this.sudahCheckOut,
        jamMasuk: jamMasuk ?? this.jamMasuk,
        jamKeluar: jamKeluar ?? this.jamKeluar,
        mingguIni: mingguIni,
        totalHadirBulanIni: totalHadirBulanIni,
        totalTerlambat: totalTerlambat,
      );

  @override
  List<Object?> get props =>
      [sudahCheckIn, sudahCheckOut, jamMasuk, jamKeluar];
}

// ---------- Cubit ----------
class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(const AttendanceState());

  void checkIn() {
    final now = DateTime.now();
    final jam =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    emit(state.copyWith(sudahCheckIn: true, jamMasuk: jam));
  }

  void checkOut() {
    final now = DateTime.now();
    final jam =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    emit(state.copyWith(sudahCheckOut: true, jamKeluar: jam));
  }
}
