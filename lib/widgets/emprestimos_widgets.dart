import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hora_do_conto/views/renovar_emprestimo.dart';

class EmprestimosWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emprestimos;
  final bool Function(String status) isEmprestado;

  const EmprestimosWidget({
    Key? key,
    required this.emprestimos,
    required this.isEmprestado,
  }) : super(key: key);

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

          final bool podeRenovar = isEmprestado(status);

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
            trailing: podeRenovar
                ? ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RenovarEmprestimoDialog(
                            onRenovar: (DateTime newDate) {
                              // Implemente aqui a lógica para renovar o empréstimo
                              // com a nova data (use o emprestimo['id'] para identificar o empréstimo).
                              // Exemplo: _renovarEmprestimo(emprestimo['id'], newDate);
                            },
                            emprestimoId:
                                emprestimo['id'], // Passe o ID do empréstimo
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Cor preta
                    ),
                    child: Text('Renovar Empréstimo'),
                  )
                : null, // Não mostra o botão se não for possível renovar
          );
        },
      ),
    );
  }
}
