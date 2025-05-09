import 'package:mysql1/mysql1.dart';

class Database {
  static Future<MySqlConnection> connect() {
    return MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'pokeapp',
    ));
  }
}
