// import 'package:bookstore/db/dao/categoria_dao.dart';
// import 'package:bookstore/model/categoria.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class CategoriesDropDown extends StatefulWidget {
//   List<Categoria> categorias;

//   Function(Categoria) callback;

//   CategoriesDropDown(
//     this.categorias,
//     this.callback, {
//     required Key key,
//   }) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _CategoriesDropDownState createState() => _CategoriesDropDownState();
// }

// class _CategoriesDropDownState extends State<CategoriesDropDown> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<Categoria>(
//         onChanged: (value) {
//           setState(() {
//             widget.callback(value!);
//           });
//         },
//         hint: const Text('Selecione uma categoria'),
//         items: widget.categorias.map((categoria) {
//           return DropdownMenuItem(
//             value: categoria,
//             child: Text(categoria.toString()),
//           );
//         }).toList());
//   }
// }
