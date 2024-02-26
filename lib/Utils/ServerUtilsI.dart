import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// interface contendo get de router
abstract interface class ServerUtils {
  Router get router;
}

///Classe abstrata responsável por disponiblizar utilidades para
///os Responses
abstract class ResponseUtils {
  /// Método que gera e retorna Responses
  static Response getResponse(List<Map<String, dynamic>> listMap) {
    try {
      return Response.ok(jsonEncode(listMap), headers: {
        'Content-Type':
            ContentType('application', 'json', charset: 'utf-8').toString()
      });
    } catch (e) {
      return Response.internalServerError(
          body: "Erro ao tentar realizar a busca, $e");
    }
  }

  /// Método responsável por transformar JSON em MAP<String, dynamic>
  static Map<String, dynamic> dadosReqMap(String strReq) => jsonDecode(strReq);

  /// Verifica campos obrigatórios não preechidos
  static String requeredItensMessage(
      List<String> listRequered, Map<String, dynamic> jsonRequest) {
    List itens = [null, "", 0, 0.0];
    for (var camp in listRequered) {
      if (itens.contains(jsonRequest[camp])) {
        return "O campo $camp é obrigatório !";
      }
    }
    return "Campo diferente dos aceitos pelo sistema detectado!";
  }

  static String autoItensMessage(
      List<String> listRequered, Map<String, dynamic> jsonRequest) {
    for (String camp in listRequered) {
      if (jsonRequest[camp] != null) {
        return "O campo $camp é definido automaticamente. Sua adição manual não é permitida !";
      }
    }
    return "Campo diferente dos aceitos pelo sistema detectado!";
  }

  static Response getBadResponse(String message) =>
    Response.badRequest(
            body: jsonEncode({"error": message}),
                headers: {'Content-Type': 'application/json'});
}
