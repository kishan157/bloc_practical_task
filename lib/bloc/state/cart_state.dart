import 'package:bloc_practical_task/models/product.dart';
import 'package:flutter/material.dart';

abstract class CartState {
  final List<Data>? cartItem;
  const CartState({@required this.cartItem});

  @override
  List<Object> get props => [];
}

class CartLoadInProgress extends CartState {}

class ProductInitialState extends CartState {
  const ProductInitialState();
}

class ProductLoadingState extends CartState {
  final String message;

  const ProductLoadingState({
    required this.message,
  });
}

class ProductSuccessState extends CartState {
  final Product product;

  const ProductSuccessState({
    required this.product,
  });
}

class ProductErrorState extends CartState {
  final String error;

  const ProductErrorState({
    required this.error,
  });
}

class ProductAdded extends CartState {
  final List<Data>? cartItem;

  const ProductAdded({@required this.cartItem}) : super(cartItem: cartItem);

  @override
  List<Object> get props => [cartItem!];

  @override
  String toString() => 'ProductAdded { todos: $cartItem }';
}

class ProductRemoved extends CartState {
  final List<Data>? cartItem;

  const ProductRemoved({@required this.cartItem}) : super(cartItem: cartItem);

  @override
  List<Object> get props => [cartItem!];

  @override
  String toString() => 'ProductRemoved { todos: $cartItem }';
}
