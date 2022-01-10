import 'package:bloc_practical_task/models/product.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class ProductFetchEvent extends CartEvent {
  const ProductFetchEvent();
}

class AddProduct extends CartEvent {
  final Data product;

  const AddProduct(this.product);

  @override
  List<Data> get props => [product];

  @override
  String toString() => 'AddProduct { index: $product }';
}

class RemoveProduct extends CartEvent {
  final Data product;

  const RemoveProduct(this.product);

  @override
  List<Data> get props => [product];

  @override
  String toString() => 'RemoveProduct { index: $product }';
}

class GetProduct extends CartEvent {
  final String? query;

  const GetProduct({this.query});

  @override
  String toString() => 'GetProduct { index: $query }';
}
