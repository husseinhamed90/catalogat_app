enum Status { initial, loading, success, failure }

class Resource<T> {
  final Status status;
  final T? data;
  final String? message;

  Resource._({required this.status, this.data, this.message});

  bool get isSuccess => status == Status.success;

  bool get isLoading => status == Status.loading;

  bool get isInitial => status == Status.initial;

  bool get isFailure => status == Status.failure;

  /// Initial state
  const Resource.initial() : status = Status.initial, data = null, message = null;
  /// Loading state
  factory Resource.loading() => Resource<T>._(status: Status.loading);

  /// Success state
  factory Resource.success(T data) => Resource<T>._(status: Status.success, data: data);

  /// Failure state
  factory Resource.failure(String message) => Resource<T>._(status: Status.failure, message: message);
}