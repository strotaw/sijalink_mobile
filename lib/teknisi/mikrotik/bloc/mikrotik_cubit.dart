import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/mikrotik_repository.dart';

class Mikrotik extends Equatable {
  final String nama;
  final String ip;
  final bool online;
  final int clientCount;
  final String uptime;
  const Mikrotik(this.nama, this.ip, this.online, this.clientCount, this.uptime);
  @override
  List<Object> get props => [nama, ip];

  factory Mikrotik.fromJson(Map<String, dynamic> json) =>
      Mikrotik(
        json['nama'] as String? ?? '',
        json['ip'] as String? ?? '',
        json['online'] as bool? ?? false,
        (json['clientCount'] as num?)?.toInt() ?? 0,
        json['uptime'] as String? ?? '',
      );
}

class MikrotikState extends Equatable {
  final List<Mikrotik> list;
  final String filter;
  const MikrotikState({this.list = const [], this.filter = 'Semua'});

  List<Mikrotik> get filtered {
    if (filter == 'Semua') return list;
    if (filter == 'Online') {
      return list.where((e) => e.online).toList();
    }
    return list.where((e) => !e.online).toList();
  }

  @override
  List<Object> get props => [list, filter];
}

class MikrotikCubit extends Cubit<MikrotikState> {
  final MikrotikRepository _repository;
  MikrotikCubit({MikrotikRepository? repository})
      : _repository = repository ?? DummyMikrotikRepository(),
        super(const MikrotikState()) {
    muatUlang();
  }

  Future<void> muatUlang() async {
    try {
      final list = await _repository.fetchMikrotik();
      if (isClosed) return;
      emit(MikrotikState(list: list, filter: state.filter));
    } catch (_) {}
  }

  void setFilter(String f) =>
      emit(MikrotikState(list: state.list, filter: f));
}
