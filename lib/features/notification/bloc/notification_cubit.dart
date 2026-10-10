import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NotifType { spkBaru, spkProses, spkSelesai, info }

class AppNotif extends Equatable {
  final String id;
  final String title;
  final String body;
  final String? spkNo;
  final NotifType type;
  final DateTime createdAt;
  final bool isRead;

  const AppNotif({
    required this.id,
    required this.title,
    required this.body,
    this.spkNo,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotif copyWith({bool? isRead}) => AppNotif(
        id: id,
        title: title,
        body: body,
        spkNo: spkNo,
        type: type,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
      );

  @override
  List<Object?> get props => [id, isRead];
}

class NotificationState extends Equatable {
  final List<AppNotif> list;
  final bool showUnreadOnly;

  const NotificationState({
    this.list = const [],
    this.showUnreadOnly = false,
  });

  @override
  List<Object> get props => [list, showUnreadOnly];

  int get unreadCount => list.where((e) => !e.isRead).length;

  List<AppNotif> get visible => showUnreadOnly
      ? list.where((e) => !e.isRead).toList()
      : list;
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit()
      : super(NotificationState(list: [
          AppNotif(
            id: 'n1',
            title: 'SPK Baru: SPK-1024',
            body:
                'Pasang Baru untuk Budi Santoso — Jl. Merpati No. 12',
            spkNo: 'SPK-1024',
            type: NotifType.spkBaru,
            createdAt: DateTime.now()
                .subtract(const Duration(hours: 1)),
          ),
          AppNotif(
            id: 'n2',
            title: 'SPK Diproses: SPK-1023',
            body:
                'Gangguan Koneksi Siti Aminah sedang dikerjakan',
            spkNo: 'SPK-1023',
            type: NotifType.spkProses,
            createdAt: DateTime.now()
                .subtract(const Duration(hours: 3)),
            isRead: true,
          ),
          AppNotif(
            id: 'n3',
            title: 'SPK Selesai: SPK-1021',
            body:
                'Migrasi Paket Dewi Lestari telah selesai',
            spkNo: 'SPK-1021',
            type: NotifType.spkSelesai,
            createdAt: DateTime.now()
                .subtract(const Duration(days: 1)),
            isRead: true,
          ),
        ]));

  void toggleUnreadOnly(bool v) =>
      emit(NotificationState(list: state.list, showUnreadOnly: v));

  void markRead(String id) {
    emit(NotificationState(
      list: state.list.map((e) => e.id == id ? e.copyWith(isRead: true) : e).toList(),
      showUnreadOnly: state.showUnreadOnly,
    ));
  }

  void markAllRead() {
    emit(NotificationState(
      list: state.list.map((e) => e.copyWith(isRead: true)).toList(),
      showUnreadOnly: state.showUnreadOnly,
    ));
  }

  void remove(String id) {
    emit(NotificationState(
      list: state.list.where((e) => e.id != id).toList(),
      showUnreadOnly: state.showUnreadOnly,
    ));
  }

  /// Dipanggil saat status SPK berubah agar muncul notif baru.
  void pushSpk(String spkNo, String jenis, NotifType type) {
    final title = switch (type) {
      NotifType.spkBaru => 'SPK Baru: $spkNo',
      NotifType.spkProses => 'SPK Diproses: $spkNo',
      NotifType.spkSelesai => 'SPK Selesai: $spkNo',
      NotifType.info => 'Info: $spkNo',
    };
    emit(NotificationState(
      list: [
        AppNotif(
          id: 'n${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          body: '$jenis — $spkNo',
          spkNo: spkNo,
          type: type,
          createdAt: DateTime.now(),
        ),
        ...state.list,
      ],
      showUnreadOnly: state.showUnreadOnly,
    ));
  }
}
