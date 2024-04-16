import 'package:bookstore/model/autor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bookstore/db/banco_helper.dart';

class AutorDao {
  static const String tableSql = ('''
        CREATE TABLE $_tableName (
          $_id INTEGER PRIMARY KEY,
          $_nome TEXT NOT NULL,
          $_sobrenome TEXT NOT NULL 
        )
      ''');

  static const String _tableName = 'autor';
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _sobrenome = 'sobrenome';

  Future<int> insert(Autor autor) async {
    final Database db = await getDatabase();
    Map<String, dynamic> autoraMap = _toMap(autor);
    return db.insert(_tableName, autoraMap);
  }

  Future<void> edit(Autor autor) async {
    final Database db = await getDatabase();
    Map<String, dynamic> autoraMap = _toMap(autor);

    await db.update(
      _tableName,
      autoraMap,
      where: '$_id = ?',
      whereArgs: [autor.id],
    );
  }

  Future<void> delete(Autor autor) async {
    final db = await getDatabase();
    await db.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [autor.id],
    );
  }

  Future<List<Autor>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Autor> autores = _toList(result);
    return autores;
  }

  Future<List<Autor>> findBytext(String query) async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'LOWER(nome) LIKE ? OR LOWER(sobrenome) LIKE ?',
      whereArgs: ['%${query.toLowerCase()}%', '%${query.toLowerCase()}%'],
    );

    List<Autor> autores = _toList(result);
    return autores;
  }

  Future<Autor> findByID(id) async {
    final db = await getDatabase();

    final Autor result = (await db.query(
      _tableName,
      where: '$_id = ?',
      whereArgs: [id],
    )) as Autor;

    return result;
  }

  Map<String, dynamic> _toMap(Autor autor) {
    final Map<String, dynamic> autoraMap = {};
    autoraMap[_nome] = autor.nome;
    autoraMap[_sobrenome] = autor.sobrenome;
    return autoraMap;
  }

  List<Autor> _toList(List<Map<String, dynamic>> result) {
    final List<Autor> autores = [];
    for (Map<String, dynamic> row in result) {
      final Autor autor = Autor(
        row[_id],
        row[_nome],
        row[_sobrenome],
      );
      autores.add(autor);
    }
    return autores;
  }
}
