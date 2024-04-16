import 'package:bookstore/model/livro.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bookstore/db/banco_helper.dart';

class LivroDao {
  static const String tableSql = ('''
        CREATE TABLE $_tableName (
          $_id INTEGER PRIMARY KEY,
          $_ano TEXTs,
          $_titulo TEXT NOT NULL,
          $_categoria INTEGER ,
          $_autor INTEGER ,
          FOREIGN KEY ($_categoria) REFERENCES categoria (id) ,
          FOREIGN KEY ($_autor) REFERENCES autor (id) 
        )
      ''');

  static const String _tableName = 'livro';
  static const String _id = 'id';
  static const String _ano = 'ano';
  static const String _titulo = 'titulo';
  static const String _autor = 'autor_id';
  static const String _categoria = 'categoria_id';

  Future<int> insert(Livro livro) async {
    final Database db = await getDatabase();
    Map<String, dynamic> livroMap = _toMap(livro);
    return db.insert(_tableName, livroMap);
  }

  Future<void> edit(Livro livro) async {
    final Database db = await getDatabase();
    Map<String, dynamic> livroaMap = _toMap(livro);

    await db.update(
      _tableName,
      livroaMap,
      where: '$_id = ?',
      whereArgs: [livro.id],
    );
  }

  Future<void> delete(Livro livro) async {
    final db = await getDatabase();
    await db.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [livro.id],
    );
  }

  Future<List<Livro>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Livro> livros = _toList(result);
    return livros;
  }

  Future<List<Livro>> findBytext(String query) async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'LOWER(titulo) LIKE ? ',
      whereArgs: ['%${query.toLowerCase()}%'],
    );

    List<Livro> livros = _toList(result);
    return livros;
  }

  Map<String, dynamic> _toMap(Livro livro) {
    final Map<String, dynamic> livroMap = {};
    livroMap[_titulo] = livro.titulo;
    livroMap[_ano] = livro.ano;
    livroMap[_autor] = livro.autor;
    livroMap[_categoria] = livro.categoria;
    return livroMap;
  }

  List<Livro> _toList(List<Map<String, dynamic>> result) {
    final List<Livro> livros = [];
    for (Map<String, dynamic> row in result) {
      final Livro livro = Livro(
        row[_id],
        row[_titulo],
        row[_ano] as String,
        row[_autor],
        row[_categoria],
      );
      livros.add(livro);
    }
    return livros;
  }
}
