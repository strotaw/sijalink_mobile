import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Mikrotik extends Equatable {
  final String nama;
  final String ip;
  final bool online;
  final int clientCount;
  final String uptime;
  const Mikrotik(this.nama, this.ip, this.online, this.clientCount, this.uptime);
  @override
  List<Object> get props => [nama, ip];
}

class MikrotikState extends Equatable {
  final List<Mikrotik> list;
  const MikrotikState({this.list = const [
    Mikrotik('MT-Pusat', '103.147.10.1', true, 248, '12d 4h'),
    Mikrotik('MT-Cabang Timur', '103.147.10.2', true, 132, '8d 11h'),
    Mikrotik('MT-Cabang Barat', '103.147.10.3', false, 0, 'offline 2h'),
  ]});
  @override
  List<Object> get props => [list];
}

class MikrotikCubit extends Cubit<MikrotikState> {
  MikrotikCubit() : super(const MikrotikState());
}
