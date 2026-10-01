import 'package:equatable/equatable.dart';

enum TeknisiMenu { beranda, customer, genieAcs, profil }

extension TeknisiMenuX on TeknisiMenu {
  String get label {
    switch (this) {
      case TeknisiMenu.beranda:
        return 'Beranda';
      case TeknisiMenu.customer:
        return 'Customer';
      case TeknisiMenu.genieAcs:
        return 'GenieACS';
      case TeknisiMenu.profil:
        return 'Profil';
    }
  }
}

class DashboardState extends Equatable {
  final TeknisiMenu activeMenu;
  const DashboardState({this.activeMenu = TeknisiMenu.beranda});

  DashboardState copyWith({TeknisiMenu? activeMenu}) =>
      DashboardState(activeMenu: activeMenu ?? this.activeMenu);

  @override
  List<Object> get props => [activeMenu];
}
