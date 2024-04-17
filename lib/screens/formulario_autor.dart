import 'package:bookstore/widgets/bottao_curto.dart';
import 'package:bookstore/widgets/bottao_largo.dart';
import 'package:bookstore/db/dao/autor_dao.dart';
import 'package:bookstore/model/autor.dart';
import 'package:bookstore/screens/home.dart';
import 'package:bookstore/screens/lista_autor.dart';
import 'package:flutter/material.dart';

class FormularioAutor extends StatefulWidget {
  final Autor? autor;

  const FormularioAutor({super.key, this.autor});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioAutorState createState() {
    return _FormularioAutorState();
  }
}

class _FormularioAutorState extends State<FormularioAutor> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerSobrenome = TextEditingController();
  final AutorDao _dao = AutorDao();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializar controladores de texto com os valores do autor, se existirem
    if (widget.autor != null) {
      _controllerNome.text = widget.autor!.nome!;
      _controllerSobrenome.text = widget.autor!.sobrenome!;
    }
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerSobrenome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.autor == null ? "Novo Autor" : "Editar Autor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controllerNome,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: UnderlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _controllerSobrenome,
                decoration: const InputDecoration(
                  labelText: 'Sobrenome',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o sobrenome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: BotaoLargo(
                    icon: Icons.save,
                    text: widget.autor == null ? 'Salvar' : 'Atualizar',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final String nome = _controllerNome.text;
                        final String sobrenome = _controllerSobrenome.text;
                        if (widget.autor == null) {
                          final newAutor = Autor(0, nome, sobrenome);
                          _dao.insert(newAutor).then((id) {
                            Navigator.pop(context);
                          });
                        } else {
                          final updatedAutor = widget.autor!
                              .copyWith(nome: nome, sobrenome: sobrenome);
                          _dao.edit(updatedAutor).then((value) {
                            Navigator.pop(context);
                          });
                        }
                      }
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
              text: 'Autor',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaAutor(),
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
