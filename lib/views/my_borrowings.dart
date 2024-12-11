// lib/screens/my_borrowings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/views/renew_borrowings/book_details_screen.dart';
import 'package:hora_do_conto/views/my_borrowings/components/Custom_app_bar.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:hora_do_conto/widgets/emprestimos_widgets.dart';
import 'package:hora_do_conto/widgets/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class MyBorrowingsScreen extends StatefulWidget {
  @override
  _MyBorrowingsScreenState createState() => _MyBorrowingsScreenState();
}

class _MyBorrowingsScreenState extends State<MyBorrowingsScreen> {
  final storage = FlutterSecureStorage();
  List<Map<String, dynamic>> emprestimos = [];
  List<Map<String, dynamic>> filteredEmprestimos = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _getUserIdAndEmprestimos();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _getUserIdAndEmprestimos() async {
    try {
      final userId = await storage.read(key: 'user_id');
      if (userId != null) {
        final response = await http.get(
          Uri.parse(
              '${Config.baseUrl}/emprestimo/listarEmprestimosUsuario/$userId'),
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
    return Theme(
      data: AppTheme.lightTheme(context),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80), // Definindo a altura do AppBar
          child: CustomAppBar(
            onSearchChanged: _filterEmprestimos,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView.builder(
            itemCount: filteredEmprestimos.length,
            itemBuilder: (context, index) {
              var emprestimo = filteredEmprestimos[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Ação de navegação para detalhes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(emprestimo),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagem do livro
                      Container(
                        height: 125,
                        width: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${Config.baseUrl}${emprestimo['imagem_capa']}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Informações do livro
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título do livro com limite de 2 linhas
                          Container(
                            width: MediaQuery.of(context).size.width -
                                140, // Ajuste para caber ao lado da imagem
                            child: Text(
                              emprestimo['tituloLivro'] ??
                                  'Título desconhecido',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2, // Limita o texto a até 2 linhas
                              overflow: TextOverflow
                                  .ellipsis, // Adiciona '...' no final, caso ultrapasse 2 linhas
                            ),
                          ),
                          SizedBox(height: 4),
                          // Data de devolução
                          Text(
                            'Devolução: ${emprestimo['dataDevolucao'] ?? 'Desconhecida'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Status do empréstimo
                          Text(
                            'Status: ${emprestimo['statusEmprestimo'] ?? 'Indefinido'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: _getStatusColor(
                                  emprestimo['statusEmprestimo']),
                            ),
                          ),
                          SizedBox(height: 8),
                          // Botão para ver detalhes
                          ElevatedButton(
                            onPressed: () {
                              // Navegar para ver detalhes
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailsScreen(emprestimo),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                            child: Text('Ver Detalhes'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'ATRASADO':
      return Colors.red; // Atrasado em vermelho
    case 'REJEITADO':
      return Colors.redAccent; // Rejeitado em vermelho escuro
    case 'PENDENTE':
      return Colors.amber; // Pendente em amarelo
    case 'EMPRESTADO':
      return Colors.green; // Emprestado em verde
    case 'DEVOLVIDO':
      return Colors.greenAccent; // Devolvido em verde claro
    default:
      return Colors.black; // Cor padrão
  }
}
