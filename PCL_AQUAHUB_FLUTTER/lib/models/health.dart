class HealthResponse {
  final String status;
  final String? db;
  final String? error;

  HealthResponse({required this.status, this.db, this.error});

  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      status: json['status']?.toString() ?? (json['db'] == 'connected' ? 'ok' : 'fail'),
      db: json['db']?.toString(),
      error: json['error']?.toString(),
    );
  }
}
