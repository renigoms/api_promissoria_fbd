import 'package:postgres/postgres.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';

class ConnectDataBase {
  final String host, _database, _username, _password;

  ConnectDataBase(this._database, this._username, this._password,
      {this.host = 'localhost'});

  /// Construtor recebendo um mapa com ou sem host
  factory ConnectDataBase.connectionMap(Map dataMap) {
    if (UtilsGeral.isKeysExists("host", dataMap)) {
      return ConnectDataBase(
          dataMap['database'], dataMap['username'], dataMap['password'],
          host: dataMap['host']);
    }
    return ConnectDataBase(
        dataMap['database'], dataMap['username'], dataMap['password']);
  }

  /// Estabelecendo conexão
  Future<Connection?> getConnection() async {
    try {
      return await Connection.open(
          Endpoint(
              host: host,
              database: _database,
              username: _username,
              password: _password),
          settings: ConnectionSettings(sslMode: SslMode.disable));
    } catch (e, s) {
      print("Erro ao realizar Conexão, ${e.toString()}");
      print(s);
      return null;
    }
  }
}
