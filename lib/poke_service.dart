import 'dart:convert';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

class PokeService {
  final MySqlConnection conn;
  final int userId;

  PokeService({required this.conn, required this.userId});

 Future<void> buscarPokemon() async {
  stdout.write('\nIngresa el nombre del Pokémon: ');
  final input = stdin.readLineSync()!.toLowerCase();

  final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$input');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final name = data['name'];
      final type = data['types'][0]['type']['name'];
      final height = data['height'];
      final weight = data['weight'];

      print('\nPokémon encontrado:');
      print('Nombre: $name');
      print('Tipo: $type');
      print('Altura: $height');
      print('Peso: $weight');

    
      stdout.write('\n¿Deseas ver sus habilidades? (s/n): ');
      final verHabilidades = stdin.readLineSync()!.toLowerCase();

      if (verHabilidades == 's') {
        final abilities = (data['abilities'] as List)  
            .map((a) => a['ability']['name'] as String)  
            .toList();

        print('Habilidades: ${abilities.join(', ')}');
      }

      
      stdout.write('\n¿Deseas guardarlo como favorito? (s/n): ');
      final favorito = stdin.readLineSync()!.toLowerCase();

      if (favorito == 's') {
        await conn.query(
          'INSERT INTO favorites (user_id, pokemon_name) VALUES (?, ?)',
          [userId, name],
        );
        print('Pokémon guardado como favorito.');
      }
    } else {
      print('Pokémon no encontrado. Verifica el nombre.');
    }
  } catch (e) {
    print('Error al consultar la API: $e');
  }
}

  Future<void> verFavoritos() async {
    final results = await conn.query(
      'SELECT pokemon_name FROM favorites WHERE user_id = ?',
      [userId],
    );

    if (results.isEmpty) {
      print('\nNo tienes favoritos guardados.');
    } else {
      print('\n--- Tus Pokémon Favoritos ---');
      for (var row in results) {
        print('- ${row[0]}');
      }
    }
  }
}
