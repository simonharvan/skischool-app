class Result<T> {
  ResultState state;
  T data;

  Result({this.state = ResultState.standard, this.data});
}

enum ResultState { standard, loading, error }
