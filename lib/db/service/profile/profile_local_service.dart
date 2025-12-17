import 'package:hive/hive.dart';
import 'package:project_management/db/model/profile/profile_local_model.dart';

class ProfileLocalService {
  static const String _boxName = 'profile_local_box';
  static const String _profileKey = 'logged_in_profile';

  static final ProfileLocalService _instance = ProfileLocalService._internal();
  factory ProfileLocalService() => _instance;
  ProfileLocalService._internal();

  late Box<ProfileLocalModel> _profileBox;

  /// Initialize Hive and open the box
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ProfileLocalModelAdapter());
    }
    _profileBox = await Hive.openBox<ProfileLocalModel>(_boxName);
  }

  /// Save profile data
  Future<void> saveProfile(ProfileLocalModel profile) async {
    await _profileBox.put(_profileKey, profile);
  }

  /// Retrieve stored profile
  ProfileLocalModel? getProfile() => _profileBox.get(_profileKey);

  /// Update profile (replace existing data)
  Future<void> updateProfile(ProfileLocalModel updatedProfile) async {
    await _profileBox.put(_profileKey, updatedProfile);
  }

  /// Delete stored profile (e.g., on logout)
  Future<void> deleteProfile() async => await _profileBox.delete(_profileKey);

  /// Close the box (optional)
  Future<void> dispose() async => await _profileBox.close();

  // -------------------------------
  // Convenience getters
  // -------------------------------

  String? get userName => getProfile()?.name;
  String? get userPhoto => getProfile()?.photo;
  String? get userId => getProfile()?.id?.toString();
  String? get userMobile => getProfile()?.mobile;
  String? get userEmail => getProfile()?.email;
  String? get userBirthday => getProfile()?.birthday;
  String? get userEducation => getProfile()?.education;
  String? get userProfession => getProfile()?.profession;
  String? get userAddress => getProfile()?.address;
  int? get userGender => getProfile()?.gender;

  bool get hasProfile => getProfile() != null;
}
