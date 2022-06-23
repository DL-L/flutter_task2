import 'package:laravel_echo/laravel_echo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// const String BEARER_TOKEN = '9|aAWQ9czFngtYfvHvKVn9fpvtYIev0igRg1D2bIA9';
Echo initSocketIOClient({String? token}) {
  IO.Socket socket = IO.io(
    'ws://10.0.2.2:6001',
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
          'Authorization': 'Bearer ${token}',
        }
      },
    },
  );
  return echo;
}
