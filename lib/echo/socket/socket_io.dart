import 'package:laravel_echo/laravel_echo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// const String BEARER_TOKEN = '9|aAWQ9czFngtYfvHvKVn9fpvtYIev0igRg1D2bIA9';
Echo initSocketIOClient() {
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  IO.Socket socket = IO.io(
    'http://localhost:6001',
    IO.OptionBuilder()
        .disableAutoConnect()
        .setTransports(['websocket']).build(),
  );

  Echo echo = new Echo(
    broadcaster: EchoBroadcasterType.SocketIO,
    client: socket,
    options: {
      'auth': {
        'headers': {
          'Authorization': 'Bearer $_getToken()',
        }
      },
    },
  );

  return echo;
}
