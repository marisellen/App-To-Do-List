import 'package:app_to_do_list/login/login_page.dart';
import 'package:app_to_do_list/menu/home_page.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
>>>>>>> SextaVer

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page'; // Usado para navegação por rotas
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  void _register() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode adicionar a lógica de registro
      // Se o registro for bem-sucedido, navegue para a HomePage
      Navigator.of(context).pushReplacementNamed(HomePage.tag);
    }
  }

=======
  // Método para registrar com e-mail e senha
  Future<void> _registerWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.of(context).pushReplacementNamed(HomePage.tag);
      } catch (e) {
        _showErrorDialog('Erro ao registrar: ${e.toString()}');
      }
    }
  }

  // Método para registrar com conta do Google
  Future<void> _registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Usuário cancelou

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pushReplacementNamed(HomePage.tag);
    } catch (e) {
      _showErrorDialog('Erro ao registrar com Google: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

>>>>>>> SextaVer
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo de e-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo de senha
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

<<<<<<< HEAD
              // Botão de registro
              ElevatedButton(
                onPressed: _register,
                child: const Text('Cadastrar'),
=======
              // Botão de registro com e-mail
              ElevatedButton(
                onPressed: _registerWithEmail,
                child: const Text('Cadastrar com E-mail'),
              ),
              const SizedBox(height: 16.0),

              // Botão de registro com Google
              ElevatedButton.icon(
                onPressed: _registerWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Cadastrar com Google'),
>>>>>>> SextaVer
              ),
              const SizedBox(height: 16.0),

              // Link para login
              TextButton(
                onPressed: () {
<<<<<<< HEAD
                  Navigator.of(context).pushNamed(LoginPage.tag); // Navega para a página de login
=======
                  Navigator.of(context)
                      .pushNamed(LoginPage.tag); // Navega para a página de login
>>>>>>> SextaVer
                },
                child: const Text('Já tem uma conta? Faça login!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
