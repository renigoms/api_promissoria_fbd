import 'dart:convert';
import 'dart:mirrors';

import 'package:postgres/legacy.dart';
import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import 'model.dart';

class DAOClientes implements DAOUtilsI {
  @override
  String createTable() =>  SQLCliente.CREATE_TABLE;

  /// Método estático que tem como objetivo transformar o retorno de querys
  /// do tipo SELECT em uma lista de maps
  Future<List<Map<String, dynamic>>>_getSelectMap(String query) async{
    final dados = await Cursor.query(query);
    final listMapDados =  dados!.map((element) => element.toColumnMap()).toList();
    return [for(Map<String, dynamic> map in listMapDados) Cliente.byMap(map).toMap()];
  }

  Future<List<Map<String, dynamic>>> getAll()  {
    String query = SQLCliente.SELECTALL;
    return _getSelectMap(query);
  }

  Future<List<Map<String, dynamic>>> getByID(String id)  {
    String query = sprintf(SQLCliente.SELECTBYID, [id]);
    return _getSelectMap(query);
  }

  Future<List<Map<String, dynamic>>> getByName(String cpf) {
    final query = sprintf(SQLCliente.SELECTBYCPF, ["'$cpf'"]);
    return _getSelectMap(query);
  }

  Future<bool> postCreateCliente(Cliente cliente) async{
    try {
      String query = sprintf(SQLCliente.CREATE, [cliente.nome_completo,
      cliente.cpf,cliente.email, cliente.telefone]);
      return await Cursor.execute(query);
    } on PostgreSQLException catch(e){
      if(e.message.contains("duplicate key value violates unique constraint")){
        rethrow;
      }
      return false;
    }catch(e){
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }
  }

  Future<bool> updateCliente(Cliente cliente) async{
    try{
      if (cliente.id == null) throw IDException();
      List oldCliente = await getByID(cliente.id.toString());

      String id = cliente.id.toString(),
          nome_completo = cliente.nome_completo == null ?
          oldCliente[0]['nome_completo'] : cliente.nome_completo,
          cpf = cliente.cpf == null ?
              oldCliente[0]['cpf']:cliente.cpf,
          email = cliente.email == null ?
          oldCliente[0]['email']: cliente.email,
          telefone = cliente.telefone==null ?
              oldCliente[0]['telefone']:cliente.telefone;
      
      final query = sprintf(SQLCliente.UPDATE,
          [nome_completo, cpf, email, telefone, id]);
      return await Cursor.execute(query);
    }on IDException{
      rethrow;
    }catch(e, s){
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }

  Future<bool> deleteCliente(String id) async{
    try{
      if (id.isEmpty) throw IDException();
      final query = sprintf(SQLCliente.DELETE, [id]);
      return await Cursor.execute(query);
    }on IDException{
      rethrow;
    } catch(e){
        print("Erro ao deletar, $e");
        return false;
    }

  }


}
