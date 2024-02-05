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
    for (String camp in listRequered) {
      if (jsonRequest[camp] == null) return "O campo $camp é obrigatório !";
    }
    return "";
  }
  static String autoItensMessage(
      List<String> listRequered, Map<String, dynamic> jsonRequest) {
    for (String camp in listRequered) {
      if (jsonRequest[camp] != null) return "O campo $camp é definido automaticamente. Sua adição manual não é permitida !";
    }
    return "";
  }
}
