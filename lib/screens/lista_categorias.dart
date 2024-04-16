import 'package:bookstore/components/bottao_curto.dart';
import 'package:bookstore/db/dao/categoria_dao.dart';
import 'package:bookstore/model/categoria.dart';
import 'package:bookstore/screens/formulario_categoria.dart';
import 'package:bookstore/screens/home.dart';
import 'package:flutter/material.dart';

class ListaCategoria extends StatefulWidget {
  const ListaCategoria({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListaCategoriaState createState() {
    return _ListaCategoriaState();
  }
}

class _ListaCategoriaState extends State<ListaCategoria> {
  final CategoriaDao _dao = CategoriaDao();

  bool _isLoading = false;
  List<Categoria> _categorias = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  void _carregarCategorias() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final categorias = await (_searchQuery.isEmpty
          ? _dao.findAll()
          : _dao.findBytext(_searchQuery));
      setState(() {
        _categorias = categorias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Tratar o erro de forma adequada, como exibir uma mensagem de erro para o usuário.
      // ignore: avoid_print
      debugPrint("Erro ao carregar categorias: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Pesquisar categorias...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
            _carregarCategorias();
          },
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Carregando categorias...'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      categoria.descricao.toString(),
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    subtitle: Text(
                      "${categoria.descricao}",
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FormularioCategoria(categoria: categoria),
                              ),
                            );
                            _carregarCategorias();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar exclusão"),
                                  content: const Text(
                                      "Tem certeza de que deseja excluir esta categoria?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Excluir"),
                                      onPressed: () {
                                        _dao.delete(categoria);
                                        Navigator.of(context).pop();
                                        _carregarCategorias();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BotaoCurto(
              icon: Icons.home,
              text: 'Home',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            ),
            BotaoCurto(
              icon: Icons.add,
              text: 'Categoria',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioCategoria(),
                  ),
                );
                // Após adicionar um autor, recarrega a lista
                _carregarCategorias();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriaItem extends StatelessWidget {
  final Categoria categoria;
  const _CategoriaItem(this.categoria);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          categoria.descricao.toString(),
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          categoria.descricao.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
