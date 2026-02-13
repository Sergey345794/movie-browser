sealed class Failure {
  const Failure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class ApiFailure extends Failure {
  const ApiFailure();
}

class EmptyResultsFailure extends Failure {
  const EmptyResultsFailure();
}

class TooManyResultsFailure extends Failure {
  const TooManyResultsFailure();
}

class MovieNotFoundFailure extends Failure {
  const MovieNotFoundFailure();
}

class UnknownFailure extends Failure {
  const UnknownFailure();
}
