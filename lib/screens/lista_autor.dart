import 'package:bookstore/components/bottao_curto.dart';
import 'package:bookstore/db/dao/autor_dao.dart';
import 'package:bookstore/model/autor.dart';
import 'package:bookstore/screens/formulario_autor.dart';
import 'package:bookstore/screens/home.dart';
import 'package:flutter/material.dart';

class ListaAutor extends StatefulWidget {
  const ListaAutor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListaAutorState createState() {
    return _ListaAutorState();
  }
}

class _ListaAutorState extends State<ListaAutor> {
  final AutorDao _dao = AutorDao();
  bool _isLoading = false;
  List<Autor> _autores = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _carregarAutores();
  }

  void _carregarAutores() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final autores = await (_searchQuery.isEmpty
          ? _dao.findAll()
          : _dao.findBytext(_searchQuery));
      setState(() {
        _autores = autores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      debugPrint("Erro ao carregar autores: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Pesquisar autor...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
            _carregarAutores();
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
                  Text('Carregando autores...'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _autores.length,
              itemBuilder: (context, index) {
                final autor = _autores[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      autor.sobrenome.toString(),
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    subtitle: Text(
                      "${autor.nome} ${autor.sobrenome}",
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
                                    FormularioAutor(autor: autor),
                              ),
                            );
                            _carregarAutores();
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
                                      "Tem certeza de que deseja excluir este autor?"),
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
                                        _dao.delete(autor);
                                        Navigator.of(context).pop();
                                        _carregarAutores();
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
              text: 'Autor',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioAutor(),
                  ),
                );
                // Após adicionar um autor, recarrega a lista
                _carregarAutores();
              },
            ),
          ],
        ),
      ),
    );
  }
}
