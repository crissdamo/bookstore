import 'package:bookstore/widgets/bottao_curto.dart';
import 'package:bookstore/widgets/bottao_largo.dart';
import 'package:bookstore/db/dao/categoria_dao.dart';
import 'package:bookstore/model/categoria.dart';
import 'package:bookstore/screens/home.dart';
import 'package:bookstore/screens/lista_categorias.dart';
import 'package:flutter/material.dart';

class FormularioCategoria extends StatefulWidget {
  final Categoria? categoria;
  const FormularioCategoria({super.key, this.categoria});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioCategoriaState createState() {
    return _FormularioCategoriaState();
  }
}

class _FormularioCategoriaState extends State<FormularioCategoria> {
  final TextEditingController _controllerDescricao = TextEditingController();
  final CategoriaDao _dao = CategoriaDao();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializar controladores de texto com os valores do autor, se existirem
    if (widget.categoria != null) {
      _controllerDescricao.text = widget.categoria!.descricao!;
    }
  }

  @override
  void dispose() {
    _controllerDescricao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Nova Categoria"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controllerDescricao,
                decoration: const InputDecoration(
                    labelText: 'Descrição da Categoria',
                    border: UnderlineInputBorder()),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a Descrição da categoria.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: BotaoLargo(
                    icon: Icons.save,
                    text: widget.categoria == null ? 'Salvar' : 'Atualizar',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final String descricao = _controllerDescricao.text;

                        if (widget.categoria == null) {
                          final newCategoria = Categoria(0, descricao);
                          _dao.insert(newCategoria).then((id) {
                            Navigator.pop(context);
                          });
                        } else {
                          final updateCategoria =
                              widget.categoria!.copyWith(descricao: descricao);
                          _dao.edit(updateCategoria).then((value) {
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
              text: 'Categoria',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaCategoria(),
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
