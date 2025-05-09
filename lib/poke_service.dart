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

      print('\n¡Pokémon encontrado!:');
      print('Nombre: $name');
      print('Tipo: $type');
      print('Altura: $height');
      print('Peso: $weight');

      await conn.query(
        'INSERT INTO searches (user_id, pokemon_name, type, height, weight) VALUES (?, ?, ?, ?, ?)',
        [userId, name, type, height, weight],
      );

    } else {
      print('¡Vaya! Parece que no he podido encontrar ese Pokemon...');
    }
  }
}
