import 'dart:convert';

import 'package:bloc_practical_task/bloc/state/cart_state.dart';
import 'package:bloc_practical_task/models/product.dart';
import 'package:bloc_practical_task/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event/cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.productRepository}) : super(ProductAdded(cartItem: []));

  final List<Data> _cartItems = [];
  List<Data> get items => _cartItems;

  final ProductRepository productRepository;
  int page = 1;
  bool isFetching = false;


  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is ProductFetchEvent) {
      yield ProductLoadingState(message: 'Loading Products');
      final response = await productRepository.getProductList(page: page);
      Product product = Product.fromJson(response);
        if (product.status == 200) {
          yield ProductSuccessState(
            product: product,
          );
          page++;
        } else {
          yield ProductErrorState(error: product.message!);
        }
    } else if (event is RemoveProduct) {
      _cartItems.clear();
      await productRepository.deleteProduct(event.product.id!);
      _cartItems.addAll(await productRepository.getProducts());
      yield ProductRemoved(cartItem: _cartItems);
    }else if (event is AddProduct) {
      _cartItems.clear();
        await productRepository.addProduct(event.product);
      _cartItems.addAll(await productRepository.getProducts());
        yield ProductAdded(cartItem: _cartItems);
    } else if (event is GetProduct) {
      _cartItems.clear();
      _cartItems.addAll(await productRepository.getProducts(query: event.query));
        yield ProductAdded(cartItem: _cartItems);
    }
  }
}
