import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class InitServer{
  static Future<bool> init(Handler handler, String address, int port) async{
    try{
      final servidor = await shelf_io.serve(handler, address, port);
      print('http://${servidor.address.host}:${servidor.port}');
      return true;
    }catch(e){
      print('Erro ao inicializar servidor, ${e.toString()}');
      return false;
    }

  }

  static Handler initPipelane(Handler handler){
    return Pipeline().addMiddleware(logRequests()).addHandler(handler);
  }
}