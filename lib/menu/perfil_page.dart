import 'package:flutter/material.dart';

import 'contato_page.dart';
import 'dadosPessoais_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variável para armazenar a imagem do perfil
  String? _imagePath;

  // Definindo a cor do cabeçalho diretamente no código
  final Color _headerColor =
      Color.fromARGB(168, 204, 171, 244); // Altere essa cor conforme necessário

  // Função para escolher a imagem (aqui pode ser o código para pegar a imagem do dispositivo)
  void _changeImage() async {
    setState(() {
      _imagePath = 'assets/fotoPerfil.png'; // Exemplo de imagem
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _headerColor, // Cor do cabeçalho
        title: const Text("Meu Perfil"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _changeImage, // Ao clicar, muda a foto
                  child: Container(
                    width: 50.0, // Tamanho do quadrado
                    height: 50.0, // Tamanho do quadrado
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _imagePath == null
                            ? const AssetImage('assets/fotoPerfil.png')
                            : AssetImage(_imagePath!) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: _imagePath == null
                        ? const Icon(Icons.camera_alt,
                            size: 4, color: Color.fromARGB(168, 204, 171, 244))
                        : null,
                  ),
                ),
                const SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(168, 204, 171, 244),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'Email: user@example.com',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.person, color: Color.fromARGB(168, 204, 171, 244)),
            title: const Text('Dados Pessoais',
                style: TextStyle(
                    color: Color.fromARGB(168, 204, 171, 244), fontSize: 13)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PersonalDataPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone,
                color: Color.fromARGB(168, 204, 171, 244)),
            title: const Text('Contato',
                style: TextStyle(
                    color: Color.fromARGB(168, 204, 171, 244), fontSize: 13)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
