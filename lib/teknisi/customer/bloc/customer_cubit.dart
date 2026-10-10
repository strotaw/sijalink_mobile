import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/customer_repository.dart';

class Customer extends Equatable {
  final String nama;
  final String id;
  final String alamat;
  final String telp;
  final String tglPemasangan;
  final String paket;
  final String status;
  // Detail hardware / koneksi
  final String pppoeUser;
  final String pppoePass;
  final String odp;
  final String mikrotik;

  const Customer(
    this.nama,
    this.id,
    this.paket,
    this.status, {
    this.alamat = '-',
    this.telp = '-',
    this.tglPemasangan = '-',
    this.pppoeUser = '-',
    this.pppoePass = '-',
    this.odp = '-',
    this.mikrotik = '-',
  });

  @override
  List<Object> get props => [id];

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(
        json['nama'] as String? ?? '',
        json['id'] as String? ?? '',
        json['paket'] as String? ?? '',
        json['status'] as String? ?? '',
        alamat: json['alamat'] as String? ?? '-',
        telp: json['telp'] as String? ?? '-',
        tglPemasangan: json['tglPemasangan'] as String? ?? '-',
        pppoeUser: json['pppoeUser'] as String? ?? '-',
        pppoePass: json['pppoePass'] as String? ?? '-',
        odp: json['odp'] as String? ?? '-',
        mikrotik: json['mikrotik'] as String? ?? '-',
      );
}

class CustomerState extends Equatable {
  final String query;
  final String filter;
  final List<Customer> all;
  const CustomerState(
      {this.query = '', this.filter = 'Semua', this.all = const []});

  List<Customer> get filtered {
    final byStatus = filter == 'Semua'
        ? all
        : filter == 'Tidak Aktif'
            ? all.where((c) => c.status != 'Aktif').toList()
            : all.where((c) => c.status == filter).toList();
    if (query.isEmpty) return byStatus;
    return byStatus.where((c) =>
        c.nama.toLowerCase().contains(query.toLowerCase()) ||
        c.id.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  List<Object> get props => [query, filter, all];
}

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerRepository _repository;
  CustomerCubit({CustomerRepository? repository})
      : _repository = repository ?? DummyCustomerRepository(),
        super(const CustomerState()) {
    muatUlang();
  }

  Future<void> muatUlang() async {
    try {
      final all = await _repository.fetchCustomer();
      if (isClosed) return;
      emit(CustomerState(
          query: state.query, filter: state.filter, all: all));
    } catch (_) {}
  }

  void search(String q) =>
      emit(CustomerState(query: q, filter: state.filter, all: state.all));
  void setFilter(String f) =>
      emit(CustomerState(query: state.query, filter: f, all: state.all));
}
