/// Backend configuration for ShifaQ Doctor.
///
/// Environments (from `lib/web/src/environments/*` in the Angular reference):
///   dev      -> http://localhost:3000
///   staging  -> https://staging-api.shifaq.com
///   prod     -> https://api.shifaq.com
class ApiConfig {
  ApiConfig._();

  /// When `true`, the app talks to an in-memory fake server (`MockApiClient`)
  /// so every screen works without a real backend. Set to `false` to make real
  /// HTTP calls to [baseUrl].
  ///
  /// This is a plain field (not `const`) so tests can turn the mock on.
  static bool useMockApi = false;

  /// Base URL for real HTTP calls. Override at build time with
  /// `--dart-define=API_BASE_URL=https://...`.
  static const String baseUrl = 'https://api.shifaq.com';

  /// The OTP the mock server accepts.
  static const String mockOtp = '1234';

  /// How long to wait for a real HTTP response before giving up.
  static const Duration timeout = Duration(seconds: 20);
}
