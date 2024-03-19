import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/socket/app_sockect_functions.dart';
import 'package:web_socket_channel/io.dart';
import "package:web_socket_channel/status.dart" as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class GameWebSocket extends ChangeNotifier {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  void connectWebSocket(BuildContext context,
      {required int? gameId, required int? sessionId}) {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    _channel = IOWebSocketChannel.connect('$halloaGameSocketUrl$accessToken'
        '&session_id=$sessionId&current_game_id=$gameId');

    _subscription = _channel?.stream.listen(
      (message) {
// Handle received messages
        AppSocketFunctions()
            .allGameFunctions(context: context, message: message);
      },
      onError: (error) {
// Handle errors
        _channel?.sink.close(status.goingAway);

        if (_channel?.closeCode != null) {
          connectWebSocket(context, gameId: gameId, sessionId: sessionId);
        }
      },
      onDone: () {
        // Handle WebSocket connection closed
        //     lg('WebSocket connection closed');
        _channel?.sink.close(status.goingAway);

        if (_channel?.closeCode != null) {
          connectWebSocket(context, gameId: gameId, sessionId: sessionId);
        }
      },
    );
  }

  startGame() {
    _channel?.sink.add(jsonEncode({'type': 'start_game'}));
  }

  pauseGame() {
    _channel?.sink.add(jsonEncode({'type': 'pause_game'}));
  }

  endGame() {
    _channel?.sink.add(jsonEncode({'type': 'end_game'}));
  }

  void closeSocket() {
    if (_subscription != null) {
      _subscription?.cancel();
    }

    if (_channel != null) {
      _channel?.sink.close();
    }
  }
}
