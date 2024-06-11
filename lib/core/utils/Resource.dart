
import 'package:equatable/equatable.dart';

import 'Status.dart';

class Resource<T> extends Equatable{
  STATUS status;
  T? data;
  String? message;

  Resource({required this.status,  this.data,  this.message});

  static Resource success({data,message}) => Resource(status: STATUS.SUCCESS, data: data, message: message);
  static Resource error({message}) => Resource(status: STATUS.ERROR, data: null, message: message);
  static Resource loading() => Resource(status: STATUS.LOADING, data: null, message: "Loading...");


  @override
  String toString() {
    return 'Resource{status: $status, data: $data, message: $message}';
  }

  Resource copyWith({STATUS? status, required T data, String? messege}){
    return Resource(status: status??this.status,data: data??this.data,message: messege??this.message);
  }
  @override
  List<Object> get props => [status,data!,message!];
}

class Stack<T>extends Equatable {
  List<T> _stack = [];

  void push(T item) => _stack.add(item);

  T pop() => _stack.removeLast();
  @override
  List<Object> get props => [_stack];
}
