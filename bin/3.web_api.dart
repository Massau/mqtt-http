import 'dart:convert';

import 'package:dio/dio.dart';

import 'constantes.dart';

Future<String> postMensagem(String mensagem) async {
  // var body = json.encode(mensagem);
  // ignore: omit_local_variable_types
  String retorno = '';
  // ignore: omit_local_variable_types
  Response requisicao = await dio.post(
    baseUrlRequisicao,
    data: mensagem,
    options: Options(
      // ignore: prefer_single_quotes
      headers: {"Accept": "application/json"},
    ),
  );

  print('{requisicao.statusCode: ${requisicao.statusCode}}');
  if (requisicao.statusCode == 201 && requisicao.data != null) {
    var retornoRequisicao = json.decode(requisicao.data);
    print('mensagem requisicao: $retornoRequisicao');
    retorno = retornoRequisicao['mensagem'].toString();
  }

  return retorno;
}

Future<String> getRetornoMensagem(String id) async {
  // ignore: omit_local_variable_types
  String retorno = '';
  // ignore: omit_local_variable_types
  Response requisicao = await dio.get(
    baseUrlRequisicao + '?id=$id',
  );

  print('requisicao.statusCode: ${requisicao.statusCode}');
  if (requisicao.statusCode == 201 && requisicao.data != null) {
    retorno = requisicao.data;
  }

  return retorno;
}
