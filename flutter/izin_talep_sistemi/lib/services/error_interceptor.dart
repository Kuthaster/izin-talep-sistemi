import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/exceptions/api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = "Beklenmeyen bir hata oluştu.";

    if (err.response != null) {
      final data = err.response?.data;
      if (data is Map<String, dynamic>) {
        final errorTitle = data['error'] ?? 'Hata';
        final errorDetail = data['message'] ?? 'Bilinmeyen bir hata oluştu';

        // Example output: "Kimlik Doğrulama Hatası: Şifre yanlış"
        errorMessage = '$errorTitle: $errorDetail';
      }
    } else {
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Bağlantı zaman aşımına uğradı.";
      } else if (err.type == DioExceptionType.connectionError) {
        errorMessage = "İnternet bağlantınızı kontrol edin.";
      }
    }

    final apiException = ApiException(errorMessage, err.response?.statusCode);

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException, // We store our clean error here!
        message: errorMessage,
      ),
    );
  }
}
