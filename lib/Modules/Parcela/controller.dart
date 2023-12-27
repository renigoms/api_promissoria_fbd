

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Parcela/DAO.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ParcelaHandlerController implements ServerUtils{
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    route.get("/<id_contrato>", (Request request, String id_contrato) async{
      return ResponseUtils.getResponse(await DAOParcela().getByIdContrato(id_contrato));
    });

    route.post("/", (Request request)async{
      final mapIDContrato = ResponseUtils.dadosReqMap(await request.readAsString());
      return await DAOParcela().postCreate(mapIDContrato['id_contrato'].toString())
          ? Response.ok("Parcelas criadas com sucesso!")
          : Response.internalServerError(
          body: "Erro durante a criação das parcelas detectado!");
    });
    return route;
  }


}