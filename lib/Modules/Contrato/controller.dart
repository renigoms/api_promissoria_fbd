import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Contrato/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

class ContratoHandlerController implements ServerUtils {
  @override
  // TODO: implement router
  Router get router {
    final route = Router();

    route.get(
        "/",
        (Request request) async =>
            ResponseUtils.getResponse(await DAOContrato().getAll()));

    route.get(
        "/<id>",
        (Request request, String id) async =>
            ResponseUtils.getResponse(await DAOContrato().getByID(id)));

    route.get(
        "/nome_cliente/<nome_cliente>",
        (Request request, String nome_cliente) async =>
            ResponseUtils.getResponse(await DAOContrato().getByClienteName(nome_cliente)));

    route.post("/", (Request request) async {
     try{
       return await DAOContrato().postCreate(Contrato.byMap(
           ResponseUtils.dadosReqMap(await request.readAsString())))
           ? Response.ok("Contrato cadastrado com sucesso!")
           : Response.internalServerError(
           body: "Erro durante o cadastro detectado!");
     }on NullException{
       return Response.badRequest(body: "Alguns atributos necessários "
           "não foram preenchidos!");
     }
    });

    route.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOContrato().delete(id)
            ? Response.ok("Contrato e parcelas deletadas")
            : Response.internalServerError(
                body: "Erro durante a tentativa de delete");
      } on IDException {
        return Response.badRequest(
            body: "Você precisa fornecer o ID do produto que quer deletar!");
      } on ParcelasEmAbertoExcerption {
        return Response.badRequest(
            body: "Ainda existem parcelas em aberto nesse contrato!");
      }
    });

    return route;
  }
}
