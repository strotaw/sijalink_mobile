import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/ticket_repository.dart';

enum TicketStatus { baru, proses, selesai }

class Ticket extends Equatable {
  final String no;
  final String customer;
  final String judul;
  final String prioritas;
  final TicketStatus status;
  const Ticket(
      this.no, this.customer, this.judul, this.prioritas, this.status);
  @override
  List<Object> get props => [no];

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        json['no'] as String? ?? '',
        json['customer'] as String? ?? '',
        json['judul'] as String? ?? '',
        json['prioritas'] as String? ?? '',
        TicketStatus.values.firstWhere(
          (e) =>
              e.name ==
              (json['status'] as String? ?? 'baru'),
          orElse: () => TicketStatus.baru,
        ),
      );
}

class TicketState extends Equatable {
  final List<Ticket> list;
  final String filter;
  const TicketState({this.list = const [], this.filter = 'Semua'});
  @override
  List<Object> get props => [list, filter];

  List<Ticket> get filtered {
    if (filter == 'Semua') return list;
    return list
        .where((e) =>
            e.status.name.toLowerCase() ==
            filter.toLowerCase())
        .toList();
  }

  List<Ticket> get aktif =>
      list.where((e) => e.status != TicketStatus.selesai).toList();
}

class TicketCubit extends Cubit<TicketState> {
  final TicketRepository _repository;
  TicketCubit({TicketRepository? repository})
      : _repository = repository ?? DummyTicketRepository(),
        super(const TicketState()) {
    muatUlang();
  }

  Future<void> muatUlang() async {
    try {
      final list = await _repository.fetchTiket();
      if (isClosed) return;
      emit(TicketState(list: list, filter: state.filter));
    } catch (_) {}
  }

  void setFilter(String f) =>
      emit(TicketState(list: state.list, filter: f));
  void updateStatus(String no, TicketStatus s) {
    final updated = state.list
        .map((e) => e.no == no
            ? Ticket(e.no, e.customer, e.judul, e.prioritas, s)
            : e)
        .toList();
    emit(TicketState(list: updated, filter: state.filter));
  }
}
