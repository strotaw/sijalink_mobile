import '../bloc/profile_cubit.dart';

/// Kontrak data profil teknisi.
abstract class ProfileRepository {
  Future<ProfileState> fetchProfile();
}

class DummyProfileRepository implements ProfileRepository {
  @override
  Future<ProfileState> fetchProfile() async =>
      const ProfileState();
}
