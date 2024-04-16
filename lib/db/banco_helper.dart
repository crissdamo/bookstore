import 'dart:async';
import 'package:bookstore/db/dao/autor_dao.dart';
import 'package:bookstore/db/dao/categoria_dao.dart';
import 'package:bookstore/db/dao/livro_dao.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  String arquivoDoBancoDeDados = 'bookstore.db';
  String caminhoBD = await getDatabasesPath();

  final String path = join(caminhoBD, arquivoDoBancoDeDados);

  return await openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(CategoriaDao.tableSql);
      db.execute(AutorDao.tableSql);
      db.execute(LivroDao.tableSql);
    },
    version: 3,
  );
}
