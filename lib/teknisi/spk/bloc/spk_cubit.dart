import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/spk_repository.dart';

enum SpkStatus { baru, proses, selesai }

class Spk extends Equatable {
  final String no;
  final String customer;
  final String jenis;
  final String alamat;
  final SpkStatus status;
  const Spk(this.no, this.customer, this.jenis, this.alamat, this.status);
  @override
  List<Object> get props => [no];

  /// Parsing JSON backend → model. Contoh:
  /// `{"no":"SPK-1024","customer":"Budi","jenis":"Pasang Baru",
  /// "alamat":"Jl. X","status":"baru"}`
  factory Spk.fromJson(Map<String, dynamic> json) => Spk(
        json['no'] as String? ?? '',
        json['customer'] as String? ?? '',
        json['jenis'] as String? ?? '',
        json['alamat'] as String? ?? '',
        SpkStatus.values.firstWhere(
          (e) =>
              e.name ==
              (json['status'] as String? ?? 'baru'),
          orElse: () => SpkStatus.baru,
        ),
      );
}

class SpkState extends Equatable {
  final List<Spk> list;
  final String filter;
  const SpkState({this.list = const [], this.filter = 'Semua'});
  @override
  List<Object> get props => [list, filter];

  List<Spk> get filtered {
    if (filter == 'Semua') return list;
    return list.where((e) => e.status.name.toLowerCase() == filter.toLowerCase()).toList();
  }
}

class SpkCubit extends Cubit<SpkState> {
  final SpkRepository _repository;
  SpkCubit({SpkRepository? repository})
      : _repository = repository ?? DummySpkRepository(),
        super(const SpkState()) {
    muatUlang();
  }

  /// Ambil data terbaru (dari dummy / API). Dipanggil otomatis
  /// saat cubit dibuat; panggil lagi untuk pull-to-refresh.
  Future<void> muatUlang() async {
    try {
      final list = await _repository.fetchSpk();
      if (isClosed) return;
      emit(SpkState(list: list, filter: state.filter));
    } catch (_) {
      // Gagal jaringan: pertahankan state terakhir.
    }
  }

  void setFilter(String f) => emit(SpkState(list: state.list, filter: f));
  void updateStatus(String no, SpkStatus s) {
    final updated = state.list
        .map((e) => e.no == no ? Spk(e.no, e.customer, e.jenis, e.alamat, s) : e)
        .toList();
    emit(SpkState(list: updated, filter: state.filter));
  }
}
