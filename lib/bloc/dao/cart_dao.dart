
import 'package:bloc_practical_task/bloc/database/database_provider.dart';
import 'package:bloc_practical_task/models/product.dart';

class CartDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Data>> getProducts({List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>>? result;
    if (query != null && query != '') {
      if (query.isNotEmpty) {
        result = await db.query(cartTable,
            columns: columns, where: 'name LIKE ?', whereArgs: ['%$query%']);
      }
    } else {
      result = await db.query(cartTable, columns: columns);
    }

    List<Data> products = result!.isNotEmpty
        ? result.map((product) => Data.fromJson(product)).toList()
        : [];
    return products;
  }

  Future<int> addProduct(Data product) async {
    final db = await dbProvider.database;
    var queryResult = await db.rawQuery('SELECT * FROM $cartTable WHERE id=${product.id}');
    var result;
    if(queryResult.isNotEmpty){
      product.qty = (int.parse(queryResult.first['qty'].toString()) + 1);
      result = await db.update(cartTable, product.toJson(),where: 'id = ?', whereArgs: [product.id]);
    } else {
      product.qty = 1;
      result = await db.insert(cartTable, product.toJson());
    }

    return result;
  }

  Future<int> updateProduct(Data product) async {
    final db = await dbProvider.database;

    var result = await db.update(cartTable, product.toJson(),
        where: 'id = ?', whereArgs: [product.id]);

    return result;
  }

  Future<int> deleteProduct(int id) async {
    final db = await dbProvider.database;

    var result = await db.delete(cartTable, where: 'id = ?', whereArgs: [id]);

    return result;
  }
}