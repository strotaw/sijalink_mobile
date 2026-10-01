import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
}

class SpkState extends Equatable {
  final List<Spk> list;
  final String filter;
  const SpkState({this.list = const [
    Spk('SPK-1024', 'Budi Santoso', 'Pasang Baru', 'Jl. Merpati No. 12', SpkStatus.baru),
    Spk('SPK-1023', 'Siti Aminah', 'Gangguan Koneksi', 'Jl. Kenanga No. 8', SpkStatus.proses),
    Spk('SPK-1022', 'Andi Pratama', 'Maintenance ODP', 'Jl. Mawar No. 3', SpkStatus.proses),
    Spk('SPK-1021', 'Dewi Lestari', 'Migrasi Paket', 'Jl. Anggrek No. 21', SpkStatus.selesai),
  ], this.filter = 'Semua'});
  @override
  List<Object> get props => [list, filter];

  List<Spk> get filtered {
    if (filter == 'Semua') return list;
    return list.where((e) => e.status.name.toLowerCase() == filter.toLowerCase()).toList();
  }
}

class SpkCubit extends Cubit<SpkState> {
  SpkCubit() : super(const SpkState());
  void setFilter(String f) => emit(SpkState(list: state.list, filter: f));
  void updateStatus(String no, SpkStatus s) {
    final updated = state.list
        .map((e) => e.no == no ? Spk(e.no, e.customer, e.jenis, e.alamat, s) : e)
        .toList();
    emit(SpkState(list: updated, filter: state.filter));
  }
}
