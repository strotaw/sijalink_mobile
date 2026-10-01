import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Customer extends Equatable {
  final String nama;
  final String id;
  final String paket;
  final String status;
  const Customer(this.nama, this.id, this.paket, this.status);
  @override
  List<Object> get props => [id];
}

class CustomerState extends Equatable {
  final String query;
  final List<Customer> all;
  const CustomerState({this.query = '', this.all = const [
    Customer('Budi Santoso', 'C-001', '50 Mbps', 'Aktif'),
    Customer('Siti Aminah', 'C-002', '20 Mbps', 'Aktif'),
    Customer('Andi Pratama', 'C-003', '100 Mbps', 'Isolir'),
    Customer('Dewi Lestari', 'C-004', '30 Mbps', 'Aktif'),
    Customer('Joko Susilo', 'C-005', '50 Mbps', 'Aktif'),
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
