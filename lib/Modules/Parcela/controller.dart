

import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Modules/Parcela/DAO.dart';
import 'package:sistema_promissorias/Modules/Parcela/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ParcelaHandlerController implements ServerUtils{
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    route.get("/<id_contrato>", (Request request, String id_contrato) async=>
        ResponseUtils.getResponse(await DAOParcela().getByIdContrato(id_contrato))
    );

    route.get("/<id_contrato>/<data_pag>", (Request request, String id_contrato, String data_pag)async=>
       ResponseUtils.getResponse(await DAOParcela().getByDataPag(id_contrato, data_pag))
    );

    route.post("/", (Request request)async{
      try{
        return await DAOParcela().postCreate(Contrato.byMap(
          ResponseUtils.dadosReqMap(await request.readAsString())
        ))
            ? Response.ok("Parcelas criadas com sucesso!")
            : Response.internalServerError(
            body: "Erro durante a criação das parcelas detectado!");
      }on IDException{
        return Response.badRequest(
          body: "Você deve passar o id do contrato!"
        );
      }on ParcelasDefinidasException{
        return Response.badRequest(
          body: "As parcelas desse contrato já foram definidas!"
        );
      }
    });

    route.put('/<id_contrato>/<data_pag>', (Request request, String id_contrato, String data_pag) async{
      try{
        return await DAOParcela().putUpdate(Parcela.byMap(
            ResponseUtils.dadosReqMap(await request.readAsString())),id_contrato, data_pag)
      ? Response.ok("Updates realizados com sucesso!")
          : Response.internalServerError(body: "Falha no update!");
      }on NoAlterException{
        return Response.badRequest(
          body: "Você deve alterar o status e somente o status"
        );
      }on IDException{
        return Response.badRequest(body: "Você deve passar o id do contrato "
            "e a data da parcela que deseja quitar");
      }catch(e){
        return Response.internalServerError(body: "Erro ao tentar realizar as alterações solicitadas!");
      }
    });

    return route;
  }




}