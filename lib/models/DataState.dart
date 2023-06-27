import '../enums/enums.dart';

class DataState<T> {
  T? data;
  DataStateType? type;
  String? message;

  DataState.data({this.data}) : type = DataStateType.data;

  DataState.error({this.message}) : type = DataStateType.error;

  DataState.loading() : type = DataStateType.loading;

  DataState.idle() : type = DataStateType.idle;
}
