class ApiError implements Exception {
  final String message;

  ApiError({required this.message});

  factory ApiError.fromMap(Map<String, dynamic> map) {
    return ApiError(message: map['message'] ?? '알 수 없는 오류');
  }

  @override
  String toString() => message;
}