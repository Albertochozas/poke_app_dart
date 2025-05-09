import 'dart:io';
import 'package:mysql1/mysql1.dart';

class Usuario {
  final String username;
  final String password;

  Usuario({required this.username, required this.password});

  static Future<void> registrar(MySqlConnection conn) async {
    stdout.write('Nuevo usuario: ');
    final username = stdin.readLineSync()!;
    stdout.write('Contraseña: ');
    final password = stdin.readLineSync()!;

    try {
      await conn.query(
        'INSERT INTO users (username, password) VALUES (?, ?)',
        [username, password],
      );
      print('¡Usuario registrado con éxito!');
    } catch (e) {
      print('Error: usuario ya existe o problema al registrar.');
    }
  }

  static Future<int?> login(MySqlConnection conn) async {
    stdout.write('Usuario: ');
    final username = stdin.readLineSync()!;
    stdout.write('Contraseña: ');
    final password = stdin.readLineSync()!;

    final results = await conn.query(
      'SELECT id FROM users WHERE username = ? AND password = ?',
      [username, password],
    );

    if (results.isNotEmpty) {
      print('¡Login exitoso!');
      return results.first[0] as int;
    } else {
      print('Usuario o contraseña incorrectos.');
      return null;
    }
  }
}
