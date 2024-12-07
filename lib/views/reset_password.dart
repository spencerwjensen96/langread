import 'package:flutter/material.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:langread/views/components/AppBar.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _pbService = PocketBaseService();

  Future<void> _requestResetPassword() async {
    final email = _emailController.text;

    if (email.isNotEmpty) {
      await _pbService.auth.requestResetPassword(email);
      // Navigate to the main screen or show success message
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/reset-password-sent', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const MainAppBar(title: 'Request Password Change', homeButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _requestResetPassword,
                  child: const Text('Request Password Change'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordSentScreen extends StatelessWidget {
  const ResetPasswordSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
          title: 'Password Change Requested', homeButton: true),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'A password change request has been sent to your email.'),
                  const SizedBox(height: 16),
              const Text(
                  'Please check your email and follow the instructions to change your password.'),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
