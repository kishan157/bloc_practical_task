import 'package:bloc_practical_task/bloc/cart_bloc.dart';
import 'package:bloc_practical_task/bloc/event/cart_event.dart';
import 'package:bloc_practical_task/bloc/state/cart_state.dart';
import 'package:bloc_practical_task/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_tile.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

final List<Data> _products = [];
final ScrollController _scrollController = ScrollController();
int? totalPage;
class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(listener: (context, productState) {

      if (productState is ProductLoadingState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(productState.message)));
      } else if (productState is ProductSuccessState && productState.product.data!.length == 0) {
        totalPage = 0;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No more products')));
      } else if (productState is ProductErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(productState.error)));
        BlocProvider.of<CartBloc>(context).isFetching = false;
      }
      return;
    },builder: (context, productState) {
      if (productState is ProductInitialState ||
          productState is ProductLoadingState && _products.isEmpty) {
        return Center(child: CircularProgressIndicator());
      } else if (productState is ProductSuccessState) {
        if(totalPage ==null){
          totalPage = productState.product.totalPage!;
        } else{
          totalPage = totalPage! - 1;
        }
        _products.addAll(productState.product.data!);
        BlocProvider.of<CartBloc>(context).isFetching = false;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else if (productState is ProductErrorState && _products.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                BlocProvider.of<CartBloc>(context)
                  ..isFetching = true
                  ..add(ProductFetchEvent());
              },
              icon: Icon(Icons.refresh),
            ),
            const SizedBox(height: 15),
            Text(productState.error, textAlign: TextAlign.center),
          ],
        );
      }
      print(_products.length);
      return LayoutBuilder(builder: (context, constraints) {
        return GridView.builder(
          controller: _scrollController
            ..addListener(() {
              if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent &&
                  !BlocProvider.of<CartBloc>(context).isFetching) {
                if(totalPage == null || totalPage! > 0) {
                  BlocProvider.of<CartBloc>(context)
                    ..isFetching = true
                    ..add(ProductFetchEvent())..add(GetProduct());
                }
              }
            }),
          itemCount: _products.length,
          itemBuilder: (context, index) => ProductTile(_products[index]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 700 ? 3 : 2,
          ),
        );
      });
    });
  }
}