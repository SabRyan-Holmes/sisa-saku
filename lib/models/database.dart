import 'dart:io';

import 'package:drift/drift.dart';
// These imports are used to open the database
import 'package:drift/native.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sisasaku/models/category.dart';
import 'package:sisasaku/models/transaction_with_category.dart';
import 'package:sisasaku/models/transactions.dart';

part 'database.g.dart';

@DriftDatabase(
  // relative import for the drift file. Drift also supports `package:`
  // imports
  tables: [Categories, Transactions],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> getTotalAmountForTypeAndDate(int type) {
    final query = customSelect(
      'SELECT SUM(amount) AS totalAmount FROM transactions '
      'WHERE category_id IN ('
      '  SELECT id FROM categories WHERE type = ?'
      ') ',
      variables: [
        Variable.withInt(type),
      ],
      readsFrom: {transactions, categories},
    );

    return query.map((row) => row.read<int>('totalAmount')).getSingle();
  }

  Future<int> countType(int type) {
    final query = customSelect(
      'SELECT COUNT(amount) AS countType FROM transactions '
      'WHERE category_id IN ('
      '  SELECT id FROM categories WHERE type = ?'
      ') ',
      variables: [
        Variable.withInt(type),
      ],
      readsFrom: {transactions, categories},
    );

    return query.map((row) => row.read<int>('countType')).getSingle();
  }

// CRUD
  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)..where((tbl) => tbl.type.equals(type)))
        .get();
  }

// Update
  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id))).write(
      CategoriesCompanion(name: Value(name)),
    );
  }

  Future updateTransactionRepo(int id, int amount, int categoryId,
      DateTime transactionDate, String deskripsi) async {
    return (update(transactions)..where((tbl) => tbl.id.equals(id))).write(
      TransactionsCompanion(
        name: Value(deskripsi),
        amount: Value(amount),
        category_id: Value(categoryId),
        transaction_date: Value(transactionDate),
      ),
    );
  }

// Delete
  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future deleteTransactionRepo(int id) async {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  // transaksi
  Stream<List<TransactionWithCategory>> getTransactionByDate(DateTime date) {
    final query = (select(transactions).join([
      innerJoin(
        categories,
        categories.id.equalsExp(transactions.category_id),
      ),
    ])
      ..where(transactions.transaction_date.equals(date)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
