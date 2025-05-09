import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

class PokeService {
  final MySqlConnection conn;
  final int userId;

  PokeService({required this.conn, required this.userId});

  Future<void> buscarPokemon() async {
    stdout.write('Nombre del Pokémon: ');
    final name = stdin.readLineSync()!.toLowerCase();

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final type = data['types'][0]['type']['name'];
      final height = data['height'];
      final weight = data['weight'];

      print('\nPokémon encontrado:');
      print('Nombre: $name');
      print('Tipo: $type');
      print('Altura: $height');
      print('Peso: $weight');

      await conn.query(
        'INSERT INTO searches (user_id, pokemon_name, type, height, weight) VALUES (?, ?, ?, ?, ?)',
        [userId, name, type, height, weight],
      );

      stdout.write('\n¿Deseas ver sus habilidades? (s/n): ');
      final verHabilidades = stdin.readLineSync()!.toLowerCase();

      if (verHabilidades == 's') {
        final abilities = data['abilities']
            .map<String>((a) => a['ability']['name'] as String)
            .join(', ');
        print('Habilidades: $abilities');
      }

    } else {
      print('Pokémon no encontrado.');
    }
  }
}