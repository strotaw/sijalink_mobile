import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
}

class TicketState extends Equatable {
  final List<Ticket> list;
  final String filter;
  const TicketState({this.list = const [
    Ticket('TKT-3012', 'Budi Santoso', 'Internet lambat di jam sibuk',
        'Sedang', TicketStatus.baru),
    Ticket('TKT-3011', 'Siti Aminah', 'WiFi sering putus',
        'Tinggi', TicketStatus.proses),
    Ticket('TKT-3010', 'Andi Pratama', 'Tidak bisa konek PPPoE',
        'Tinggi', TicketStatus.proses),
    Ticket('TKT-3009', 'Dewi Lestari', 'Ganti password WiFi',
        'Rendah', TicketStatus.selesai),
  ], this.filter = 'Semua'});
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
  TicketCubit() : super(const TicketState());
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
