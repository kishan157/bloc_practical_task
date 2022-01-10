import 'dart:convert';

import 'package:bloc_practical_task/bloc/dao/cart_dao.dart';
import 'package:bloc_practical_task/models/product.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  static final ProductRepository _productRepository = ProductRepository._();

  ProductRepository._();

  factory ProductRepository() {
    return _productRepository;
  }

  final userDao = CartDao();

  Future getProducts({String? query}) => userDao.getProducts(query: query);

  Future addProduct(Data user) => userDao.addProduct(user);

  Future deleteProduct(int id) => userDao.deleteProduct(id);

  Future<dynamic> getProductList({
    required int page,
  }) async {
    try {
      print("page $page");
      Dio _dio = Dio();
      _dio.options.headers = {
        'token':
        'eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz',
      };
      final response = await _dio
          .post('http://205.134.254.135/~mobile/MtProject/api/v1/product_list', data: jsonEncode({"page": page, "perPage": 5}))
          .onError((DioError error, stackTrace) {
        print(error);
        return error.response!;
      }).catchError((error){
        print(error);
      });
      print(response.toString());
      return response.data;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}