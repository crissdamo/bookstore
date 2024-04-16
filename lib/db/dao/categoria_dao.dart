import 'package:bookstore/model/categoria.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bookstore/db/banco_helper.dart';

class CategoriaDao {
  static const String tableSql = ('''
        CREATE TABLE $_tableName (
          $_id INTEGER PRIMARY KEY,
          $_descricao TEXT NOT NULL 
        )
      ''');

  static const String _tableName = 'categoria';
  static const String _id = 'id';
  static const String _descricao = 'descricao';

  Future<int> insert(Categoria categoria) async {
    final Database db = await getDatabase();
    Map<String, dynamic> categoriaMap = _toMap(categoria);
    return db.insert(_tableName, categoriaMap);
  }

  Future<void> edit(Categoria categoria) async {
    final Database db = await getDatabase();
    Map<String, dynamic> categoriaaMap = _toMap(categoria);

    await db.update(
      _tableName,
      categoriaaMap,
      where: '$_id = ?',
      whereArgs: [categoria.id],
    );
  }

  Future<void> delete(Categoria categoria) async {
    final db = await getDatabase();
    await db.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [categoria.id],
    );
  }

  Future<List<Categoria>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Categoria> categorias = _toList(result);
    return categorias;
  }

  Future<List<Categoria>> findBytext(String query) async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'LOWER(descricao) LIKE ? ',
      whereArgs: ['%${query.toLowerCase()}%'],
    );

    List<Categoria> categorias = _toList(result);
    return categorias;
  }

  Future<Categoria> findByID(id) async {
    final db = await getDatabase();

    final Categoria result = (await db.query(
      _tableName,
      where: '$_id = ?',
      whereArgs: [id],
    )) as Categoria;

    return result;
  }

  Map<String, dynamic> _toMap(Categoria categoria) {
    final Map<String, dynamic> categoriaMap = {};
    categoriaMap[_descricao] = categoria.descricao;
    return categoriaMap;
  }

  List<Categoria> _toList(List<Map<String, dynamic>> result) {
    final List<Categoria> categorias = [];
    for (Map<String, dynamic> row in result) {
      final Categoria categoria = Categoria(
        row[_id],
        row[_descricao],
      );
      categorias.add(categoria);
    }
    return categorias;
  }
}
