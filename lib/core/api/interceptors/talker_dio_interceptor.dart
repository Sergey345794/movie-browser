import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../l10n/app_localizations.dart';

class TalkerDioInterceptor extends Interceptor {
  final AppLocalizations l10n;

  TalkerDioInterceptor({required this.l10n});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final uri = options.uri.toString();
      final method = options.method;

      debugPrint(l10n.logApiRequest(method, uri));

      if (options.queryParameters.containsKey('s')) {
        debugPrint(
            l10n.logSearchQuery(options.queryParameters['s'].toString()));
      }

      if (options.queryParameters.containsKey('page')) {
        debugPrint(
            l10n.logPagination(options.queryParameters['page'].toString()));
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final statusCode = response.statusCode ?? 0;
      final uri = response.requestOptions.uri.toString();

      debugPrint(l10n.logApiResponse(statusCode, uri));

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['Response'] == 'False') {
          debugPrint(l10n.logApiErrorReturned(data['Error'].toString()));
        }
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final uri = err.requestOptions.uri.toString();
      final errorType = err.type.toString();

      debugPrint(l10n.logApiError(errorType, uri));
    }

    super.onError(err, handler);
  }
}
