import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _name = 'Usuário';
  String? _email = 'usuario@email.com';
  File? _image;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocal();
  }

  Future<void> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? _name;
      _email = prefs.getString('user_email') ?? _email;
      _nameCtrl.text = _name ?? '';
      _emailCtrl.text = _email ?? '';
    });
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameCtrl.text);
    await prefs.setString('user_email', _emailCtrl.text);
    setState(() {
      _name = _nameCtrl.text;
      _email = _emailCtrl.text;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Perfil salvo')));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : AssetImage('assets/images/placeholder-user.jpg')
                        as ImageProvider,
              ),
            ),
            SizedBox(height: 12),
            TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: 'Nome')),
            SizedBox(height: 8),
            TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _saveLocal, child: Text('Salvar')),
            SizedBox(height: 12),
            OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Enviar link de recuperação para $_email')));
                },
                child: Text('Recuperar senha')),
          ],
        ),
      ),
    );
  }
}
