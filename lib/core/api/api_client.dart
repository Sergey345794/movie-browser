import 'package:dio/dio.dart';
import '../l10n/app_localizations.dart';
import '../logging/talker_service.dart';
import 'api_endpoints.dart';
import 'interceptors/talker_dio_interceptor.dart';

class ApiClient {
  final Dio _dio;
  final String apiKey;

  ApiClient({
    required this.apiKey,
    required TalkerService talkerService,
    required AppLocalizations l10n,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        ) {
    _dio.interceptors.add(TalkerDioInterceptor(l10n: l10n));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final params = {
      'apikey': apiKey,
      ...?queryParameters,
    };

    return await _dio.get(
      path,
      queryParameters: params,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final params = {
      'apikey': apiKey,
      ...?queryParameters,
    };

    return await _dio.post(
      path,
      data: data,
      queryParameters: params,
    );
  }
}
