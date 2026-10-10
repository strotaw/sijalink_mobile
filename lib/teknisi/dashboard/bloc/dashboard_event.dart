import 'package:equatable/equatable.dart';
import 'dashboard_state.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object> get props => [];
}

class MenuChanged extends DashboardEvent {
  final TeknisiMenu menu;
  const MenuChanged(this.menu);
  @override
  List<Object> get props => [menu];
}
