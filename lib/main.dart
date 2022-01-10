
import 'package:bloc_practical_task/repository/product_repository.dart';
import 'package:bloc_practical_task/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cart_bloc.dart';
import 'bloc/event/cart_event.dart';
import 'bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
        BlocProvider<CartBloc>(
        create: (BuildContext context) => CartBloc(productRepository: ProductRepository())..add(ProductFetchEvent())..add(GetProduct()),
        ),
    ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
