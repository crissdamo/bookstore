import 'package:bookstore/widgets/bottao_curto.dart';
import 'package:bookstore/db/dao/livro_dao.dart';
import 'package:bookstore/model/livro.dart';
import 'package:bookstore/screens/formulario_livro.dart';
import 'package:bookstore/screens/home.dart';
import 'package:flutter/material.dart';

class ListaLivro extends StatefulWidget {
  const ListaLivro({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListaLivroState createState() {
    return _ListaLivroState();
  }
}

class _ListaLivroState extends State<ListaLivro> {
  final LivroDao _dao = LivroDao();

  bool _isLoading = false;
  List<Livro> _livros = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  void _carregarLivros() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final livros = await (_searchQuery.isEmpty
          ? _dao.findAll()
          : _dao.findBytext(_searchQuery));
      setState(() {
        _livros = livros;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Tratar o erro de forma adequada, como exibir uma mensagem de erro para o usuário.
      // ignore: avoid_print
      debugPrint("Erro ao carregar Livros: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Pesquisar livros...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
            _carregarLivros();
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
                  Text('Carregando livros...'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _livros.length,
              itemBuilder: (context, index) {
                final livro = _livros[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      livro.titulo.toString(),
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    subtitle: Text(
                      "${livro.ano}",
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
                                    FormularioLivro(livro: livro),
                              ),
                            );
                            _carregarLivros();
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
                                      "Tem certeza de que deseja excluir este livro?"),
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
                                        _dao.delete(livro);
                                        Navigator.of(context).pop();
                                        _carregarLivros();
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
                // Após adicionar um autor, recarrega a lista
                _carregarLivros();
              },
            ),
            BotaoCurto(
              icon: Icons.add,
              text: 'Livro',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioLivro(),
                  ),
                );
                // Após adicionar um autor, recarrega a lista
                _carregarLivros();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LivroItem extends StatelessWidget {
  final Livro livro;
  const _LivroItem(this.livro);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          livro.titulo.toString(),
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          livro.ano.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
