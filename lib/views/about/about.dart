import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/about/components/Custom_AppBar.dart';
import 'package:hora_do_conto/widgets/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(
          context), // Ou o tema específico que você estiver usando
      child: const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child:
              CustomAppBar(), // Usando o CustomAppBar com o título "Sobre o Projeto"
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hora do Conto IFPE - Palmares',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 16),

                // Descrição do projeto
                Text(
                  'O Projeto de Extensão "Hora do Conto da Biblioteca do Campus Palmares" tem como objetivo incentivar o hábito da leitura nas crianças de 3 a 8 anos por meio de contações de histórias, proporcionando momentos lúdicos e educativos. Esse projeto visa não só o desenvolvimento do conhecimento, mas também o auxílio no aprendizado escolar das crianças.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),

                // Campanhas de arrecadação
                Text(
                  'Campanhas de Arrecadação de Livros',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  'O projeto também realizou campanhas para arrecadação de livros infantis, incentivando a comunidade a contribuir com a doação. Essas campanhas aumentam a variedade de livros disponíveis para as crianças e promovem a inclusão e o acesso à leitura.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),

                // Sobre o aplicativo
                Text(
                  'O Aplicativo',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  'O aplicativo foi criado para facilitar o acesso à leitura de livros infantis, tanto para a comunidade interna quanto externa do campus. Ele serve como uma plataforma prática, rápida e acessível para disponibilizar o acervo de livros. Além disso, o aplicativo oferece aos estudantes de tecnologia a oportunidade de se envolver no desenvolvimento de software, colocando-os à prova e proporcionando experiência prática na área.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),

                // Conclusão
                Text(
                  'O projeto Hora do Conto não só incentiva a leitura, mas também oferece aos alunos a chance de aprender e desenvolver suas habilidades, criando um ciclo positivo de educação e inovação.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
