// ignore_for_file: implementation_imports

import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';
import 'package:sistema_promissorias/Modules/Produto/DAO.dart';
import 'package:sistema_promissorias/Modules/Produto/model.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

import '../../Service/exceptions.dart';

class ProdutoControllerHandler implements ServerUtils {
  @override
  Router get router {
    final route = Router();

    /// rota get sem parâmetro
    route.get("/", (Request request) async {

      String? search = request.url.queryParameters['search'];

      return search == null
          ? ResponseUtils.getResponse(await DAOProduto().getAll())
          : ResponseUtils.getResponse(
              await DAOProduto().getBySearch(search));

    });

    // rota post
    route.post("/", (Request request) async {
      final map = ResponseUtils.dadosReqMap(await request.readAsString());
      try {
        return await DAOProduto().postCreate(Produto.byMap(map))
            ? Response.ok("Produto cadastrado com sucesso!")
            : Response.internalServerError(
                body: "Erro durante o cadastro detectado!");
      } on PgException {
        return ResponseUtils.getBadResponse("Opa, Já existe um produto com o mesmo nome!");
      } on ReactiveException {
        return Response.ok("Produto Reativado !");
      } on NullException {
        return ResponseUtils.getBadResponse(ResponseUtils.requeredItensMessage(
            DAOProduto().requeredItens(), map));
      } on IDException {
        return ResponseUtils.getBadResponse("O ID é adicionado automaticamente, por isso "
            "sua adição manual não é permitida!");
      } catch (e) {
        return ResponseUtils.getBadResponse("Erro durante o cadastro do produto: $e");
      }
    });
    //  rota put por id
    route.put("/<id>", (Request request, String id) async {
      try {
        return await DAOProduto().putUpdate(
                Produto.byMap(
                    ResponseUtils.dadosReqMap(await request.readAsString())),
                id)
            ? Response.ok("Updates realizados com sucesso!")
            : Response.internalServerError(body: "Falha no update!");
      } on PgException {
        return ResponseUtils.getBadResponse("Já existe um produto com o mesmo nome da sua alteração na base!");
      } on IDException {
        return ResponseUtils.getBadResponse("O id deve ser passado junto com os dados que serão alterados");
      } on NoAlterException {
        return ResponseUtils.getBadResponse("O id não pode ser alterado!");
      } on ProductException {
        return ResponseUtils.getBadResponse("O produto selecionado não existe na base!");
      } catch (e) {
        return ResponseUtils.getBadResponse("Falha no update: $e");
      }
    });

    /// rota delete por id
    route.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOProduto().deleteProduto(id)
            ? Response.ok("Produto deletado com sucesso!")
            : Response.internalServerError(body: "Tentativa de delete falhou!");
      } on IDException {
        return ResponseUtils.getBadResponse("Você precisa fornecer o ID do produto que quer deletar!");
      } on ForeingKeyException {
        return ResponseUtils.getBadResponse("Não foi possível excluir o seguinte produto, pois ele faz "
            "parte de um ou mais contratos ativos!");
      } on ProductException {
        return ResponseUtils.getBadResponse("O produto selecionado não existe na base!");
      } catch (e) {
        return ResponseUtils.getBadResponse("Tentativa de delete falhou: $e");
      }
    });

    return route;
  }
}
