/// Backend base URL.
///
/// IMPORTANT - adapt this to how you run the app:
/// - Android emulator  -> "http://10.0.2.2:8080"  (10.0.2.2 points to your host machine)
/// - iOS simulator      -> "http://localhost:8080"
/// - Real device         -> "http://<your-computer-LAN-IP>:8080" (e.g. http://192.168.1.42:8080)
/// - Flutter Web (Chrome) -> "http://localhost:8080"
/// - Production          -> your deployed backend URL (https://api.tondomaine.com)
///
/// You can also inject this at build time instead of hardcoding it:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}
