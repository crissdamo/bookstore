import 'package:bookstore/widgets/autor_dropdown.dart';
import 'package:bookstore/widgets/bottao_curto.dart';
import 'package:bookstore/widgets/bottao_largo.dart';
import 'package:bookstore/db/dao/autor_dao.dart';
import 'package:bookstore/db/dao/categoria_dao.dart';
import 'package:bookstore/db/dao/livro_dao.dart';
import 'package:bookstore/model/autor.dart';
import 'package:bookstore/model/categoria.dart';
import 'package:bookstore/model/livro.dart';
import 'package:bookstore/screens/home.dart';
import 'package:bookstore/screens/lista_livros.dart';
import 'package:bookstore/widgets/categoria_dropdown.dart';
import 'package:flutter/material.dart';

class FormularioLivro extends StatefulWidget {
  final Livro? livro;

  const FormularioLivro({super.key, this.livro});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioLivroState createState() {
    return _FormularioLivroState();
  }
}

class _FormularioLivroState extends State<FormularioLivro> {
  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerAno = TextEditingController();

  final LivroDao _dao = LivroDao();

  final AutorDao _daoAutor = AutorDao();
  Autor? _autorSelecionado;

  final CategoriaDao _daoCategoria = CategoriaDao();
  late Categoria _categoriaSelecionada;

  final _formKey = GlobalKey<FormState>();

  callbackCategoria(categoriaselecionada) {
    setState(() {
      _categoriaSelecionada = categoriaselecionada;
    });
  }

  callbackAutor(autorSelecionado) {
    setState(() {
      _autorSelecionado = autorSelecionado;
    });
  }

  @override
  void initState() {
    super.initState();
    // Inicializar controladores de texto com os valores do livro, se existirem
    if (widget.livro != null) {
      _controllerTitulo.text = widget.livro!.titulo!;
      _controllerAno.text = widget.livro!.ano!;
    }
  }

  @override
  void dispose() {
    _controllerTitulo.dispose();
    _controllerAno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.livro == null ? "Novo Livro" : "Editar Livro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controllerTitulo,
                decoration: const InputDecoration(
                    labelText: 'Título', border: UnderlineInputBorder()),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o título do livro.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controllerAno,
                decoration: const InputDecoration(
                    labelText: 'Ano de Publicação',
                    border: UnderlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o ano de publicação.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Autor>>(
                future: _daoAutor.findAll(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? AutoresDropDown(
                          snapshot.data!,
                          _autorSelecionado,
                          callbackAutor,
                        )
                      : const Text('Nenhum autor');
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Categoria>>(
                future: _daoCategoria.findAll(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? CategoriasDropDown(snapshot.data!, callbackCategoria)
                      : const Text('Nenhuma categorias');
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: BotaoLargo(
                    icon: Icons.save,
                    text: widget.livro == null ? 'Salvar' : 'Atualizar',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final String titulo = _controllerTitulo.text;
                        final String ano = _controllerAno.text;
                        int? categoriaId = _categoriaSelecionada.id;
                        int? autorId = _autorSelecionado!.id;

                        if (widget.livro == null) {
                          final newLivro =
                              Livro(0, titulo, ano, autorId, categoriaId);
                          _dao.insert(newLivro).then((id) {
                            Navigator.pop(context);
                          });
                        } else {
                          final updateCategoria = widget.livro!.copyWith(
                              titulo: titulo,
                              ano: ano,
                              autor: autorId,
                              categoria: categoriaId);
                          _dao.edit(updateCategoria).then((value) {
                            Navigator.pop(context);
                          });
                        }
                      }
                      // var novoLivro = Livro(0, "Quincas Borba", "1981", 2, 1);
                      // _dao.insert(novoLivro);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
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
              icon: Icons.list,
              text: 'Livro',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaLivro(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
