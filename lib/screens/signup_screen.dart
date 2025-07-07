import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  String? _success;

  void _signup() async {
    final success = await AuthService.signup(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      // Auto-login after signup
      final loginSuccess = await AuthService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (loginSuccess) {
        final token = await AuthService.getToken();
        if (token != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _error = "Signup succeeded but login failed. Try manually logging in.";
          _success = null;
        });
      }
    } else {
      setState(() {
        _error = "Signup failed. Try another username.";
        _success = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_success != null) Text(_success!, style: const TextStyle(color: Colors.green)),
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _signup, child: const Text("Signup")),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to login"),
            ),
          ],
        ),
      ),
    );
  }
}
