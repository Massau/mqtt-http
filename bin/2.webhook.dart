import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import '3.web_api.dart';
import 'constantes.dart';

// void main() async {
//   var fluxoDadosPrincipal = await compartilhamentoMsgDePorta();
//   fluxoDadosPrincipal.send(mensagemRequisicao);
// }

Future<SendPort> compartilhamentoMsgDePorta() async {
  Completer completer = Completer<SendPort>();
  var principalFluxoDadosIsolate = ReceivePort();

  principalFluxoDadosIsolate.listen((dados) {
    if (dados is SendPort) {
      var fluxoDadosIsolate = dados;
      completer.complete(fluxoDadosIsolate);
    } else {
      print(dados);
    }
  });

  await Isolate.spawn(recebeMensagem, principalFluxoDadosIsolate.sendPort);
  return completer.future;
}

void recebeMensagem(SendPort principalFluxoDadosIsolate) {
  var fluxoDadosIsolate = ReceivePort();
  principalFluxoDadosIsolate.send(fluxoDadosIsolate.sendPort);
    // ignore: omit_local_variable_types
    // Map<String, dynamic> jsonDadosEnviados = {
    //   // ignore: prefer_single_quotes
    //   "name": "morpheus",
    //   // ignore: prefer_single_quotes
    //   "job": "leader"
    // };

  fluxoDadosIsolate.listen((dados) async {
    var dados = await postMensagem(mensagemRequisicao);
    print('dados: $dados');
    exit(0);
  });

  // principalFluxoDadosIsolate.send('This is from recebeMensagem()');
}
