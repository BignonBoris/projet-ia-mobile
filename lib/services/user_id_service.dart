// lib/services/user_id_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserIdService {
  static const _userIdKey = 'unique_user_id';
  static final _uuid = Uuid();

  static Future<String> getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_userIdKey);

    if (userId == null) {
      userId = _uuid.v4(); // Génère une clé UUID
      await prefs.setString(_userIdKey, userId);
    }

    return userId;
  }
}
