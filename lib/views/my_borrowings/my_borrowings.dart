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
import 'package:timezone/data/latest.dart' as tz;
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
    tz.initializeTimeZones();
    _initializeNotifications();
    _getUserIdAndEmprestimos();
  }

  /// Inicializa as notificações locais
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

  /// Agenda uma notificação para uma data e hora específicas
  Future<void> _scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id, // ID único para a notificação
      title, // Título
      body, // Corpo
      tz.TZDateTime.from(scheduledDate, tz.local), // Data agendada
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: IOSNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    await _saveNotification(id.toString(), title, body, scheduledDate);
  }

  /// Agenda notificações com base nos empréstimos
  Future<void> _scheduleNotifications() async {
    for (var emprestimo in emprestimos) {
      DateTime dataVencimento = DateTime.parse(emprestimo['dataDevolucao']);
      if (dataVencimento.isAfter(DateTime.now()) &&
          emprestimo['statusEmprestimo'] == 'EMPRESTADO') {
        // Ajuste temporário para testar notificações
        DateTime testDate5Days = DateTime.now().add(Duration(seconds: 10));
        DateTime testDate1Day = DateTime.now().add(Duration(seconds: 20));

        // 5 dias antes (ajustado para 10 segundos no futuro)
        await _scheduleNotification(
            emprestimo['id'],
            'Livro próximo do vencimento',
            'Seu livro ${emprestimo['tituloLivro']} está perto de vencer em 5 dias.',
            testDate5Days);

        // 1 dia antes (ajustado para 20 segundos no futuro)
        await _scheduleNotification(
            emprestimo['id'] + 10000, // Evitando duplicidade de IDs
            'Livro próximo do vencimento',
            'Seu livro ${emprestimo['tituloLivro']} está muito perto de vencer amanhã.',
            testDate1Day);
      }
    }
  }

  Future<void> _saveNotification(
      String id, String title, String body, DateTime scheduledDate) async {
    final notificationsKey = 'saved_notifications';

    // Leia notificações existentes
    String? savedData = await storage.read(key: notificationsKey);
    List<dynamic> notifications =
        savedData != null ? json.decode(savedData) : [];

    // Adicione a nova notificação
    notifications.add({
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate.toIso8601String(),
    });

    // Salve novamente no storage
    await storage.write(
        key: notificationsKey, value: json.encode(notifications));
  }

  /// Obtém os empréstimos do usuário e agenda notificações
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

          // Agendar notificações para empréstimos
          await _scheduleNotifications();
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

  /// Filtra os empréstimos com base no texto de busca
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ATRASADO':
      case 'REJEITADO':
        return Colors.redAccent; // Tons de vermelho
      case 'PENDENTE':
        return Colors.amber; // Amarelo
      case 'EMPRESTADO':
      case 'DEVOLVIDO':
        return Colors.green; // Tons de verde
      default:
        return Colors.black; // Cor padrão
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
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
                      Container(
                        height: 125,
                        width: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${Config.baseUrl}${emprestimo['imagem']}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 140,
                            child: Text(
                              emprestimo['tituloLivro'] ??
                                  'Título desconhecido',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Devolução: ${emprestimo['dataDevolucao'] ?? 'Desconhecida'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Status: ${emprestimo['statusEmprestimo'] ?? 'Indefinido'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: _getStatusColor(
                                  emprestimo['statusEmprestimo']),
                            ),
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
