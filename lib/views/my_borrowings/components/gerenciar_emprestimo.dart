import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:hora_do_conto/widgets/emprestimos_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

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
          _scheduleNotifications();
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

  Future<void> _scheduleNotification(
      int id, String title, String body, DateTime dateTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // canal de notificações
      'your_channel_name', // nome do canal
      channelDescription: 'your_channel_description', // descrição do canal
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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
