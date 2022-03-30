import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '2.webhook.dart';
import 'constantes.dart';

final client = MqttServerClient('test.mosquitto.org', '');

Future<void> main() async {
  client.logging(on: false);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;

  print('Mosquitto Client conectando-se....');

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('Exceção: $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('Exceção $e');
    client.disconnect();
  }

  if (client.connectionStatus.state != MqttConnectionState.connected) {
    print('Falha na conexão com Mosquitto, status: ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  const pubTopic = 'Mensagem MQTT';
  final builder = MqttClientPayloadBuilder();
  builder.addString('Mensagem MQTT');

  print('Subscrevendo topic');
  client.subscribe(pubTopic, MqttQos.exactlyOnce);

  print('Publicando topic');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);

  mensagemRequisicao = pubTopic;
  
  var fluxoDadosPrincipal = await compartilhamentoMsgDePorta();
  fluxoDadosPrincipal.send(mensagemRequisicao);
}

void onSubscribed(String topic) {
  print('Subscrição confirmada para o tópico: $topic');
}

void onDisconnected() {
  if (client.connectionStatus.disconnectionOrigin !=
      MqttDisconnectionOrigin.solicited) {
    print('Callback não solicitado ou nulo. Encerrando');
    exit(-1);
  }
}

void onConnected() {
  print('Sucesso na Conexão');
}
