import 'package:sistema_promissorias/Modules/GeneralController.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Service/servidor.dart';

void main() async{
  /// Cria 
  /// as tabelas de um banco de dados caso ainda não exista
  await Cursor.initTables();
  //Objeto da rota
  final handler = GeneralController().handler;
  //pipeline com todas as informações proveniente do handler/rota
  // durante sua execução.
  final pipelane =  InitServer.initPipelane(handler);
  /**
   * Inicializa o servidor local passado a pipeline com o handler 
   * o dominio e a porta.
   */
  await InitServer.init(pipelane, "localhost", 8080);
}