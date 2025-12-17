import 'package:hive/hive.dart';
import 'package:project_management/db/model/remember_me/remember_me_model.dart';

class RememberMeService {
  static const String _boxName = 'remember_me_box';
  static const String _key = 'remembered_user';

  static final RememberMeService _instance = RememberMeService._internal();
  factory RememberMeService() => _instance;
  RememberMeService._internal();

  late Box<RememberMeModel> _box;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RememberMeModelAdapter());
    }
    _box = await Hive.openBox<RememberMeModel>(_boxName);
  }

  /// Save credentials
  Future<void> save(String phone, String password) async {
    await _box.put(_key, RememberMeModel(phone: phone, password: password));
  }

  /// Get saved credentials
  RememberMeModel? get() => _box.get(_key);

  /// Delete credentials
  Future<void> clear() async => await _box.delete(_key);

  /// Check if credentials exist
  bool get hasData => _box.containsKey(_key);
}
