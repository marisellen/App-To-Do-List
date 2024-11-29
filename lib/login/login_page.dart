import 'package:app_to_do_list/login/register_page.dart';
import 'package:app_to_do_list/menu/home_page.dart';
<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
>>>>>>> SextaVer

class LoginPage extends StatefulWidget {
  static String tag = 'login-page'; // Usado para navegação por rotas
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  void _login() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode adicionar a lógica de autenticação
      // Se o login for bem-sucedido, navegue para a HomePage
      Navigator.of(context).pushReplacementNamed(HomePage.tag);
    }
  }

=======
  // Método de login com e-mail/senha
  Future<void> _loginWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.of(context).pushReplacementNamed(HomePage.tag);
      } catch (e) {
        _showErrorDialog('Erro ao fazer login: ${e.toString()}');
      }
    }
  }

  // Método de login com Google
  Future<void> _loginWithGoogle() async {
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
      _showErrorDialog('Erro ao fazer login com Google: ${e.toString()}');
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
        title: const Text('To Do List'),
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
              // Botão de login
              ElevatedButton(
                onPressed: _login,
=======
              // Botão de login com e-mail
              ElevatedButton(
                onPressed: _loginWithEmail,
>>>>>>> SextaVer
                child: const Text('Login'),
              ),
              const SizedBox(height: 16.0),

<<<<<<< HEAD
              // Link para registro
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterPage.tag); // Navega para a página de registro
=======
              // Botão de login com Google
              ElevatedButton.icon(
                onPressed: _loginWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Login com Google'),
              ),
              const SizedBox(height: 16.0),

              // Link para registro
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(RegisterPage.tag); // Navega para a página de registro
>>>>>>> SextaVer
                },
                child: const Text('Não tem uma conta? Cadastre-se!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> SextaVer
