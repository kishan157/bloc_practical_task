import 'package:bloc_practical_task/bloc/cart_bloc.dart';
import 'package:bloc_practical_task/bloc/event/cart_event.dart';
import 'package:bloc_practical_task/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProductTile extends StatelessWidget {
  final Data? data;
  const ProductTile(this.data);

  @override
  Widget build(BuildContext context) {
    var cartList = BlocProvider.of<CartBloc>(context).items;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Expanded(child: Container(
              color: Colors.white,
                width: double.maxFinite,
                child: Image.network(data!.featuredImage!))),
            Expanded(
              flex: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                      child: Text(
                        '${data!.title}',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        BlocProvider.of<CartBloc>(context).add(AddProduct(data!));
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
