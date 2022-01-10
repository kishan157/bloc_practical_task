
import 'package:bloc_practical_task/bloc/cart_bloc.dart';
import 'package:bloc_practical_task/bloc/event/cart_event.dart';
import 'package:bloc_practical_task/bloc/state/cart_state.dart';
import 'package:bloc_practical_task/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class CartPage extends StatefulWidget {
  static String routeName = '/cart_page';

  @override
  _CartPageState createState() => _CartPageState();
}
final List<Data> _products = [];

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _CartList(),
              ),
            ),
            Divider(height: 4, color: Colors.white),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var cart = Provider.of<CartController>(context);
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {},
        child:  BlocBuilder<CartBloc, CartState>(
          builder: (context, productState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: productState.cartItem != null && productState.cartItem!.length > 0 ? ListView.builder(
                itemCount: productState.cartItem!.length,
                itemBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      dragDismissible: true,
                      children: [
                        SlidableAction(
                          flex: 1,
                          onPressed: (_){
                            BlocProvider.of<CartBloc>(context).add(RemoveProduct(productState.cartItem![index]));
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Remove',
                        ),
                      ],
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 125,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image.network(productState.cartItem![index].featuredImage!),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(productState.cartItem![index].title!),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Price'),
                                        Text(productState.cartItem![index].price!.toString()),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Quantity'),
                                        Text(productState.cartItem![index].qty!.toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Center(child: Text('No item founds'),),
            );
          }
        )
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int total = 0;
    return BlocBuilder<CartBloc, CartState>(
        builder: (context, productState) {
          total = 0;
          if(productState.cartItem != null && productState.cartItem!.length >0) {
            productState.cartItem!.forEach((element) {
              total = total + (element.price! * element.qty!);
            });
          }
        return Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Items: ${productState.cartItem != null ? productState.cartItem!.length.toString() : 0}',),
                Text('Grand Total: ${total.toString()}'),
              ],
            ),
          ),
        );
      }
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('My Cart'),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}