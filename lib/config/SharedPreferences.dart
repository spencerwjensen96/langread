import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig {
  static const Set<String> allowList = <String>{
    'themeMode',
    'fontSize',
    'lineHeight',
    'pb_auth',
    'lastBookRead',
  };

  static Future<SharedPreferencesWithCache> initalizeSharedPreferences() async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: allowList,
      ),
    );
    return prefsWithCache;
  }
}
