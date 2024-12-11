import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:http/http.dart' as http;

class RenovarEmprestimoDialog extends StatefulWidget {
  final Function(DateTime newDate) onRenovar;
  final int emprestimoId;

  RenovarEmprestimoDialog({
    required this.onRenovar,
    required this.emprestimoId,
  });

  @override
  _RenovarEmprestimoDialogState createState() =>
      _RenovarEmprestimoDialogState();
}

class _RenovarEmprestimoDialogState extends State<RenovarEmprestimoDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now(); // Inicializa com a data atual
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _renovarEmprestimo() async {
    try {
      final response = await http.put(
        Uri.parse(
            '${Config.baseUrl}/emprestimo/renovarEmprestimo/${widget.emprestimoId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'dataDevolucao': selectedDate.toIso8601String()}),
      );

      if (response.statusCode == 200) {
        widget.onRenovar(selectedDate); // Confirma a renovação
        Navigator.of(context).pop(); // Fechar o diálogo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Empréstimo renovado com sucesso!')),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro ao renovar empréstimo'),
            content: Text(
                'Não foi possível renovar o empréstimo. Tente novamente mais tarde.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo de erro
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro na chamada à API'),
          content:
              Text('Verifique sua conexão com a internet e tente novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo de erro
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Renovar Empréstimo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Selecione a nova data de devolução:'),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Selecionar Data'),
          ),
          Text('Data selecionada: ${selectedDate.toLocal()}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancelar
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _renovarEmprestimo, // Chama a função para renovar
          child: Text('Renovar'),
        ),
      ],
    );
  }
}
