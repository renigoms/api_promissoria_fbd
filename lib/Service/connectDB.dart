
import 'package:postgres/postgres.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';

class ConnectDataBase {
  final String host, _database, _username, _password;

  ConnectDataBase(this._database, this._username,
      this._password,{this.host = 'localhost'});


  factory ConnectDataBase.connectionMap(Map dataMap){
    if (UtilsGeral.isKeysExists("host", dataMap)) {
      return ConnectDataBase(
          dataMap['database'],
          dataMap['username'],
          dataMap['password'],
        host: dataMap['host']
      );
    }
    return ConnectDataBase(
        dataMap['database'],
        dataMap['username'],
        dataMap['password']
    );
  }

  Future <Connection?> getConnection() async{
    try{
      return await Connection.open(Endpoint(
          host: host,
          database: _database,
          username: _username,
          password: _password
      ),settings: ConnectionSettings(sslMode: SslMode.disable));
    }catch(e){
      print("Erro ao realizar Conexão, ${e.toString()}");
      return null;
    }
  }
}
