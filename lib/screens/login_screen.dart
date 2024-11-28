import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  String _selectedCountry = 'korean'; // 기본 값 설정

  Future<void> _handleLogin() async {
    final userId = int.tryParse(_userIdController.text) ?? 0;
    final country = _selectedCountry;
    final userName = _userNameController.text;

    if (userId == 0 || country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid user ID and select a country')),
      );
      return;
    }

    try {
      // AuthService의 createUser 함수를 호출하여 사용자 생성
      await AuthService.createUser(userId, userName, country);

      // HomeScreen으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userId: userId, userName: userName, country: country),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User Name'),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: const InputDecoration(labelText: 'Country'),
              items: const [
                DropdownMenuItem(
                  value: 'korean',
                  child: Text('Korean'),
                ),
                DropdownMenuItem(
                  value: 'english',
                  child: Text('English'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value ?? 'korean';
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
