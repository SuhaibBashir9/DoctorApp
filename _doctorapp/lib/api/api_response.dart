// Errors the API layer can throw. Repositories let these bubble up; the
// `BaseController.runGuarded` helper catches them and shows a snackbar.

/// The request reached the server but it rejected it (bad OTP, 404, 500, or an
/// envelope with `success: false`).
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isAuthError => statusCode == 401 || statusCode == 403;

  @override
  String toString() => message;
}

/// The server could not be reached at all (offline, DNS failure, connection
/// refused, timeout).
class ApiUnavailable extends ApiException {
  ApiUnavailable([super.message = 'Cannot reach the Shifaq server.']);
}
