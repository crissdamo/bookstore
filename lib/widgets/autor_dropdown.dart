import 'package:bookstore/model/autor.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AutoresDropDown extends StatefulWidget {
  List<Autor> autores;

  Function(Autor) callback;

  Autor? autorSelecionado;

  AutoresDropDown(
    this.autores,
    this.autorSelecionado,
    this.callback, {
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AutoresDropDownState createState() => _AutoresDropDownState();
}

class _AutoresDropDownState extends State<AutoresDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Autor>(
        hint: const Text('Selecione um autor'),
        onChanged: (Autor? value) {
          setState(() {
            if (value != null) {
              setState(() {
                widget.callback(value);
              });
            }
          });
        },
        items: widget.autores.map((autor) {
          return DropdownMenuItem(
            value: autor,
            child: Text("${autor.nome} ${autor.sobrenome}"),
          );
        }).toList());
  }
}
