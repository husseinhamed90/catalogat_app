import 'package:catalogat_app/core/dependencies.dart';

part 'api_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResult <T> {
  const ApiResult({
    this.success,
    this.message,
    this.data,
  });

  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResultFromJson(json, fromJsonT);

  final bool? success;
  final String? message;
  final T? data;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResultToJson(this, toJsonT);
}

extension ApiResponseToResource<T> on ApiResult<T> {
  Resource<U> toResource<U>([U Function(T)? transform]) {
    U Function(T) effectiveTransform = transform ?? (T data) => data as U;

    if (success != null && success == true) {
      if (T == dynamic || data != null) {
        return Resource.success(effectiveTransform(data as T),message: message);
      } else {
        return Resource.failure(message ?? "Unknown error occurred");
      }
    }
    else{
      return Resource.failure(message ?? "Unknown error occurred");
    }
  }
}