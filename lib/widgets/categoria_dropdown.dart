import 'package:bookstore/model/categoria.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoriasDropDown extends StatefulWidget {
  List<Categoria> categorias;

  Function(Categoria) callback;

  CategoriasDropDown(
    this.categorias,
    this.callback, {
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CategoriasDropDownState createState() => _CategoriasDropDownState();
}

class _CategoriasDropDownState extends State<CategoriasDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Categoria>(
        hint: const Text('Selecione uma categoria'),
        onChanged: (Categoria? value) {
          setState(() {
            if (value != null) {
              setState(() {
                widget.callback(value);
              });
            }
          });
        },
        items: widget.categorias.map((categoria) {
          return DropdownMenuItem(
            value: categoria,
            child: Text(categoria.descricao.toString()),
          );
        }).toList());
  }
}
