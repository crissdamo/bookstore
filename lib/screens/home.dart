import 'package:bookstore/widgets/bottao_largo.dart';
import 'package:bookstore/screens/lista_autor.dart';
import 'package:bookstore/screens/lista_categorias.dart';
import 'package:bookstore/screens/lista_livros.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var msgBoasVidas = 'Bem Vind@s!';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                msgBoasVidas,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            BotaoLargo(
              icon: Icons.category,
              text: 'Categoria',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaCategoria(),
                  ),
                );
              },
            ),
            BotaoLargo(
              icon: Icons.group_add,
              text: 'Autor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaAutor(),
                  ),
                );
              },
            ),
            BotaoLargo(
              icon: Icons.book,
              text: 'Livro',
              onPressed: () {
                Navigator.push(
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
