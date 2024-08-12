import 'package:flutter/material.dart';

class EmprestimosWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emprestimos;

  const EmprestimosWidget({Key? key, required this.emprestimos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: emprestimos.length,
        itemBuilder: (context, index) {
          final emprestimo = emprestimos[index];
          final titulo = emprestimo['tituloLivro'];
          final dataRetirada = emprestimo['dataRetirada'];
          final dataDevolucao = emprestimo['dataDevolucao'];
          final status = emprestimo['statusEmprestimo'];

          return ListTile(
            title: Text(titulo),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Retirada: $dataRetirada'),
                Text('Devolução: $dataDevolucao'),
                Text(status),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // Lógica para renovar o empréstimo
                // Implemente aqui a ação de renovação
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Cor preta
              ),
              child: Text('Renovar Empréstimo'),
            ),
          );
        },
      ),
    );
  }
}
