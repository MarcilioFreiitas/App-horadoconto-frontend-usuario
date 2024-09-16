import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/widgets/emprestimos_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmprestimosComponent extends StatefulWidget {
  @override
  _EmprestimosComponentState createState() => _EmprestimosComponentState();
}

class _EmprestimosComponentState extends State<EmprestimosComponent> {
  final storage = FlutterSecureStorage();
  List<Map<String, dynamic>> emprestimos = [];
  List<Map<String, dynamic>> filteredEmprestimos = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserIdAndEmprestimos();
  }

  Future<void> _getUserIdAndEmprestimos() async {
    try {
      final userId = await storage.read(key: 'user_id');
      if (userId != null) {
        final response = await http.get(
          Uri.parse(
              'http://10.0.0.107:8080/emprestimo/listarEmprestimosUsuario/$userId'),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            emprestimos = List<Map<String, dynamic>>.from(data);
            filteredEmprestimos = emprestimos;
          });
        } else {
          print('Erro na resposta: ${response.statusCode}');
        }
      } else {
        print('ID do usuário é nulo.');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }
  }

  void _filterEmprestimos(String query) {
    final filtered = emprestimos.where((emprestimo) {
      final titulo = emprestimo['tituloLivro']?.toLowerCase() ?? '';
      final input = query.toLowerCase();
      return titulo.contains(input);
    }).toList();

    setState(() {
      filteredEmprestimos = filtered;
    });
  }

  bool _isEmprestado(String status) {
    return status == 'EMPRESTADO';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('Meus Empréstimos')
            : TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.black54,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: _filterEmprestimos,
              ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filteredEmprestimos = emprestimos;
                }
              });
            },
          ),
        ],
      ),
      body: EmprestimosWidget(
        emprestimos: filteredEmprestimos,
        isEmprestado: _isEmprestado,
      ),
    );
  }
}
