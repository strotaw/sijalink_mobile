import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/genie_acs_repository.dart';

class AcsDevice extends Equatable {
  final String serial;
  final String model;
  final String customer;
  final bool online;
  const AcsDevice(this.serial, this.model, this.customer, this.online);
  @override
  List<Object> get props => [serial];

  factory AcsDevice.fromJson(Map<String, dynamic> json) =>
      AcsDevice(
        json['serial'] as String? ?? '',
        json['model'] as String? ?? '',
        json['customer'] as String? ?? '',
        json['online'] as bool? ?? false,
      );
}

class GenieAcsState extends Equatable {
  final List<AcsDevice> devices;
  const GenieAcsState({this.devices = const []});
  int get onlineCount => devices.where((d) => d.online).length;
  @override
  List<Object> get props => [devices];
}

class GenieAcsCubit extends Cubit<GenieAcsState> {
  final GenieAcsRepository _repository;
  GenieAcsCubit({GenieAcsRepository? repository})
      : _repository = repository ?? DummyGenieAcsRepository(),
        super(const GenieAcsState()) {
    muatUlang();
  }

  Future<void> muatUlang() async {
    try {
      final devices = await _repository.fetchDevices();
      if (isClosed) return;
      emit(GenieAcsState(devices: devices));
    } catch (_) {}
  }

  void reboot(String serial) {}
}
