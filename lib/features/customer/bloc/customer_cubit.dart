import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
}

class CustomerState extends Equatable {
  final String query;
  final List<Customer> all;
  const CustomerState({this.query = '', this.all = const [
    Customer('Budi Santoso', 'C-001', '50 Mbps', 'Aktif',
        alamat: 'Jl. Merpati No. 12, Timur',
        telp: '0812-3456-0001',
        tglPemasangan: '12 Jan 2024',
        pppoeUser: 'budi.santoso@pppoe',
        pppoePass: 'bd5482xQ',
        odp: 'ODP-TMR-01 / Port 4',
        mikrotik: 'MT-Cabang Timur'),
    Customer('Siti Aminah', 'C-002', '20 Mbps', 'Aktif',
        alamat: 'Jl. Kenanga No. 8, Timur',
        telp: '0812-3456-0002',
        tglPemasangan: '03 Mar 2024',
        pppoeUser: 'siti.aminah@pppoe',
        pppoePass: 'st7731mN',
        odp: 'ODP-KNG-02 / Port 1',
        mikrotik: 'MT-Cabang Timur'),
    Customer('Andi Pratama', 'C-003', '100 Mbps', 'Isolir',
        alamat: 'Jl. Mawar No. 3, Barat',
        telp: '0812-3456-0003',
        tglPemasangan: '21 Jun 2023',
        pppoeUser: 'andi.pratama@pppoe',
        pppoePass: 'an9920kL',
        odp: 'ODP-MWR-01 / Port 7',
        mikrotik: 'MT-Cabang Barat'),
    Customer('Dewi Lestari', 'C-004', '30 Mbps', 'Aktif',
        alamat: 'Jl. Anggrek No. 21, Pusat',
        telp: '0812-3456-0004',
        tglPemasangan: '15 Sep 2024',
        pppoeUser: 'dewi.lestari@pppoe',
        pppoePass: 'dw3345pZ',
        odp: 'ODP-AGG-03 / Port 2',
        mikrotik: 'MT-Pusat'),
    Customer('Joko Susilo', 'C-005', '50 Mbps', 'Aktif',
        alamat: 'Jl. Melati No. 5, Pusat',
        telp: '0812-3456-0005',
        tglPemasangan: '28 Nov 2024',
        pppoeUser: 'joko.susilo@pppoe',
        pppoePass: 'jk1108vB',
        odp: 'ODP-MLT-01 / Port 5',
        mikrotik: 'MT-Pusat'),
  ]});

  List<Customer> get filtered => query.isEmpty
      ? all
      : all.where((c) =>
          c.nama.toLowerCase().contains(query.toLowerCase()) ||
          c.id.toLowerCase().contains(query.toLowerCase())).toList();

  @override
  List<Object> get props => [query, all];
}

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(const CustomerState());
  void search(String q) => emit(CustomerState(query: q, all: state.all));
}
