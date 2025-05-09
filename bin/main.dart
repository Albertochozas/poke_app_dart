import 'dart:io';

import '../lib/database.dart';
import '../lib/usuario.dart';
import '../lib/poke_service.dart';

void main() async {
  final conn = await Database.connect();

  print('--- Bienvenido a la PokeApp ---');
  print('1. Registrarse');
  print('2. Iniciar sesión');
  stdout.write('Elige una opción: ');
  final opcion = stdin.readLineSync();

  int? userId;

  if (opcion == '1') {
    await Usuario.registrar(conn);
    userId = await Usuario.login(conn);
  } else if (opcion == '2') {
    userId = await Usuario.login(conn);
  }

  if (userId != null) {
    final pokeService = PokeService(conn: conn, userId: userId);

    var continuar = true;
    while (continuar) {
      print('\n--- Menú ---');
      print('1. Buscar Pokémon');
      print('2. Salir');
      stdout.write('Elige una opción: ');
      final seleccion = stdin.readLineSync();

      switch (seleccion) {
        case '1':
          await pokeService.buscarPokemon();
          break;
        case '2':
          continuar = false;
          break;
        default:
          print('Opción inválida.');
      }
    }
  }

  await conn.close();
}
