import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcsDevice extends Equatable {
  final String serial;
  final String model;
  final String customer;
  final bool online;
  const AcsDevice(this.serial, this.model, this.customer, this.online);
  @override
  List<Object> get props => [serial];
}

class GenieAcsState extends Equatable {
  final List<AcsDevice> devices;
  const GenieAcsState({this.devices = const [
    AcsDevice('ZTE-F609-8821', 'ZTE F609', 'Budi Santoso', true),
    AcsDevice('HUAWEI-8145-1102', 'Huawei HG8145V5', 'Siti Aminah', true),
    AcsDevice('ZTE-F609-7734', 'ZTE F609', 'Andi Pratama', false),
    AcsDevice('FIBERHOME-5520', 'Fiberhome HG6243C', 'Dewi Lestari', true),
  ]});
  int get onlineCount => devices.where((d) => d.online).length;
  @override
  List<Object> get props => [devices];
}

class GenieAcsCubit extends Cubit<GenieAcsState> {
  GenieAcsCubit() : super(const GenieAcsState());
  void reboot(String serial) {}
}
