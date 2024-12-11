import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  // Função para abrir o cliente de e-mail diretamente
  void _launchEmail() async {
    final Uri emailUri = Uri.parse(
        'mailto:luanyaggamyy@gmail.com?subject=Requisição Hora do Conto(Aplicativo)&body=Olá, sou {Nome}, identificador: {email ou cpf}, e estou entrando em contato para tratar de {assunto}.');

    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Não foi possível abrir o cliente de e-mail: $e';
    }
  }

  // Função para abrir o WhatsApp
  void _launchWhatsApp() async {
    final String phoneNumber = '+5581989898876';
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Não foi possível abrir o WhatsApp: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entre em contato conosco:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('E-mail'),
            subtitle: const Text('luanyaggamyy@gmail.com'),
            onTap: _launchEmail, // Abre o cliente de e-mail
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.whatshot_sharp, color: Colors.green),
            title: const Text('WhatsApp'),
            subtitle: const Text('+55 81 98989-8876'),
            onTap: _launchWhatsApp, // Abre o WhatsApp
          ),
        ],
      ),
    );
  }
}
