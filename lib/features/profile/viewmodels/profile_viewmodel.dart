import 'package:flutter/foundation.dart';

import '../models/profile.dart';
import '../models/profile_menu_item.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileViewModel(this.repository);

  Profile? _profile;

  Profile? get profile => _profile;

  List<ProfileMenuItem> get menus {
    return repository.getProfileMenus();
  }

  void loadProfile() {
    _profile = repository.getProfile();
    notifyListeners();
  }

  bool updateProfile({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (_profile == null) return false;

    if (password.isNotEmpty && password != confirmPassword) {
      return false;
    }

    final Profile updatedProfile = _profile!.copyWith(
      username: username,
      email: email,
    );

    repository.updateProfile(updatedProfile);

    _profile = updatedProfile;
    notifyListeners();

    return true;
  }
}
