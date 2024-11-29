import 'package:flutter/material.dart';

import 'contato_page.dart';
import 'dadosPessoais_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name = 'User';
  String? _email = 'user@example.com';
  DateTime? _birthDate = DateTime(1990, 5, 25);

  String? _imagePath;

  final Color _headerColor =
      Color.fromARGB(168, 204, 171, 244);

  void _changeImage() async {
    setState(() {
      _imagePath = 'assets/fotoPerfil.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _headerColor,
        title: const Text("Meu Perfil"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _changeImage,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
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
                    Text(
                      _name!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(168, 204, 171, 244),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Email: $_email',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Data de Nascimento: ${_birthDate != null ? '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}' : 'Não informada'}',
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
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PersonalDataPage()),
              );

              if (result != null) {
                setState(() {
                  _name = result['name'];
                  _email = result['email'];
                  _birthDate = result['birthDate'];
                });
              }
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

