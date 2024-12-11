import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  // Função para abrir o cliente de e-mail diretamente
  void _launchEmail() async {
    final Uri emailUri = Uri.parse(
        'mailto:biblioteca@palmares.ifpe.edu.br?subject=Requisição Hora do Conto (Aplicativo)&body=Olá, sou {Nome}, identificador: {email ou cpf} e estou entrando em contato porque: {assunto}.');

    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Não foi possível abrir o cliente de e-mail: $e';
    }
  }

  // Função para abrir o WhatsApp
  void _launchWhatsApp() async {
    final String phoneNumber = '+5581973327224';
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Não foi possível abrir o WhatsApp: $e';
    }
  }

  // Função para abrir o Google Maps
  void _launchGoogleMaps() async {
    final Uri mapsUri = Uri.parse(
        'https://www.google.com.br/maps/place/IFPE+-+Campus+Palmares/@-8.6848038,-35.5769612,17z/data=!3m1!4b1!4m6!3m5!1s0x7aa0aadaa16061b:0x3e0528d7fc29f529!8m2!3d-8.6848038!4d-35.5743809!16s%2Fg%2F11byq8qd8n?entry=ttu&g_ep=EgoyMDI0MTIwMi4wIKXMDSoASAFQAw%3D%3D'); // Substitua com o link do local desejado
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else {
      throw 'Não foi possível abrir o Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          // Título "Entre em contato conosco"
          const Text(
            'Entre em contato conosco:',
            style: TextStyle(
              fontSize: 18, // Tamanho reduzido
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Botão de e-mail
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: const Text('E-mail'),
            subtitle: const Text('biblioteca@palmares.ifpe.edu.br'),
            onTap: _launchEmail, // Abre o cliente de e-mail
          ),
          const Divider(),

          // Botão de WhatsApp
          ListTile(
            leading: SvgPicture.asset(
              "assets/icons/whatsapp.svg", // Caminho do arquivo SVG
              height: 24, // Altura da imagem
              width: 24, // Largura da imagem
            ),
            title: const Text('WhatsApp'),
            subtitle: const Text('+55 81 97332-7224'),
            onTap: _launchWhatsApp, // Abre o WhatsApp
          ),
          // Mensagem pedindo brevidade
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Fundo cinza claro
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.black),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Por favor, seja breve ao descrever sua solicitação para facilitar o atendimento.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Título "Onde nos achar"
          const Text(
            'Onde nos achar:',
            style: TextStyle(
              fontSize: 18, // Tamanho semelhante ao título anterior
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Botão de localização
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: const Text('Abrir no Google Maps'),
            onTap: _launchGoogleMaps, // Abre o Google Maps
          ),

          // Mensagem abaixo do Google Maps
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Fundo cinza claro
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.black),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Estamos localizados na biblioteca do IFPE- Campus Palmares. Você deverá se deslocar até a instituição para retirar e devolver os livros solicitados.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
