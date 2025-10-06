
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String error = '';

  void _login() {
    if (userCtrl.text == 'admin' && passCtrl.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(showAssetsMessage: true)),
      );
    } else {
      setState(() => error = 'Credenciales incorrectas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/logo.png', width: 100, height: 100),
                const SizedBox(height: 8),
                const Text('BeanRush',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'Usuario')),
                TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
                const SizedBox(height: 10),
                Text(error, style: const TextStyle(color: Colors.redAccent)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _login, child: const Text('Ingresar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
