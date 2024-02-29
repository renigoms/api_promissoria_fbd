import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Utils/ServerUtilsI.dart';

import 'model.dart';

class ClienteHandlerController implements ServerUtils {
  @override
  Router get router {
    final router = Router();

    /// rota get sem parâmetro
    router.get('/', (Request request) async {
      String? search = request.url.queryParameters['search'];
      return search == null
          ? ResponseUtils.getResponse(await DAOCliente().getAll())
          : ResponseUtils.getResponse(await DAOCliente().getBySearch(search));
    });

    /// rota post
    router.post('/', (Request request) async {
      final map = ResponseUtils.dadosReqMap(await request.readAsString());
      try {
        return await DAOCliente().postCreate(Cliente.byMap(map))
            ? Response.ok("Cliente cadastrado com sucesso!")
            : Response.internalServerError(
                body: "Erro durante o cadastro detectado!");
      } on PgException catch (e) {
        if (e.message.contains(
            "duplicar valor da chave viola a restrição de unicidade")) {
          return ResponseUtils.getBadResponse(
              "Opa, Já existe um cliente com o mesmo CPF que o seu!");
        }

        if (e.message
            .contains("valor é muito longo para tipo character varying(14)")) {
          return ResponseUtils.getBadResponse(
              "Opa, o cpf adicionado é maior que o permitido!");
        }

        return ResponseUtils.getBadResponse("Erro inesperado na query => $e");
      } on ReactiveException {
        return Response.ok("Cliente inativo ativado. "
              "Isso ocorreu porque já existia um cliente inativo com esse cpf na base!");
      } on NullException {
        return ResponseUtils.getBadResponse(ResponseUtils.requeredItensMessage(
            DAOCliente().requeredItens(), map));
      } on IDException {
        return ResponseUtils.getBadResponse(
            """O ID é adicionado automaticamente, por isso 
                sua adição manual não é permitida!""");
      } catch (e) {
        return ResponseUtils.getBadResponse(
            "Erro durante o cadastro do cliente: $e");
      }
    });

    // rota put por id
    router.put("/<id>", (Request request, String id) async {
      try {
        return await DAOCliente().putUpdate(
                Cliente.byMap(
                    ResponseUtils.dadosReqMap(await request.readAsString())),
                id)
            ? Response.ok("Updates realizados com sucesso!")
            : Response.internalServerError(body: "Falha no update!");
      } on IDException {
        return ResponseUtils.getBadResponse(
            "O id deve ser passado junto com os dados que serão alterados");
      } on NoAlterException {
        return ResponseUtils.getBadResponse(
            "O id do cliente não pode ser alterado!");
      } on ClientException {
        return ResponseUtils.getBadResponse(
            "O cliente selecionado não existe na base!");
      } catch (e) {
        return ResponseUtils.getBadResponse("Falha no update: $e");
      }
    });

    /// rota delete por id
    router.delete("/<id>", (Request request, String id) async {
      try {
        return await DAOCliente().delete(id)
            ? Response.ok("Cliente deletado com sucesso!")
            : Response.internalServerError(body: "Tentativa de delete falhou!");
      } on IDException {
        return ResponseUtils.getBadResponse(
            "Você precisa fornecer o ID do cliente que quer deletar");
      } on ForeingKeyException {
        return ResponseUtils.getBadResponse(
            "Não foi possível excluir o cliente, pois ele possui um ou mais contratos ativos");
      } on ClientException {
        return ResponseUtils.getBadResponse(
            "O cliente selecionado não existe na base!");
      } catch (e) {
        return ResponseUtils.getBadResponse("Tentativa de delete Falhou: $e");
      }
    });
    return router;
  }
}
