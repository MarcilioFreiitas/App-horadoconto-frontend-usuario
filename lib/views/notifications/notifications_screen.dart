import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/views/notifications/components/Custom_AppBar.dart';
import 'package:hora_do_conto/widgets/theme.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final storage = FlutterSecureStorage();
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notificationsKey = 'saved_notifications';

    // Leia notificações do storage
    String? savedData = await storage.read(key: notificationsKey);
    List<dynamic> savedNotifications =
        savedData != null ? json.decode(savedData) : [];

    setState(() {
      notifications = List<Map<String, dynamic>>.from(savedNotifications);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context), // Aplicando tema (caso haja)
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9), // Cor de fundo
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(), // Usando o CustomAppBar sem parâmetros
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 8.0), // Adicionando espaço após o AppBar
          child: notifications.isEmpty
              ? Center(child: Text('Nenhuma notificação salva.'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Adicionando espaçamento vertical
                      child: ListTile(
                        title: Text(
                            notification['title'] ?? 'Título desconhecido'),
                        subtitle: Text(notification['body'] ?? 'Sem descrição'),
                        trailing: Text(
                          notification['scheduledDate'] != null
                              ? DateTime.parse(notification['scheduledDate'])
                                  .toLocal()
                                  .toString()
                              : '',
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
