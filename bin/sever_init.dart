import 'package:sistema_promissorias/Modules/GeneralController.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Service/servidor.dart';

void main() async{
  await Cursor.initTables();

  final handler = GeneralController().handler;

  final pipelane =  InitServer.initPipelane(handler);

  await InitServer.init(pipelane, "localhost", 8080);
}