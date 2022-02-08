import 'package:flutter/material.dart';
import 'package:flutter_task2/echo/shocket_test.dart';
import 'package:flutter_task2/models/notifiers.dart';
import 'package:flutter_task2/screen/Home.dart';
import 'package:flutter_task2/screen/addTaskBottomSheet.dart';
import 'package:flutter_task2/screen/calendar.dart';
import 'package:flutter_task2/screen/login.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  final channel = IOWebSocketChannel.connect('http://127.0.0.1:6001');
  print(channel.isBlank);
  channel.stream.listen((message) {
    channel.sink.add('received!');
    channel.sink.close(status.goingAway);
  });
  // IO.Socket socket = IO.io('http://localhost:6001');
  // socket.connect();
  // socket.onConnect((_) {
  //   print('connect');
  //   socket.emit('msg', 'test');
  // });
  // socket.on('event', (data) => print(data));
  // socket.onDisconnect((_) => print('disconnect'));
  // socket.on('fromServer', (_) => print(_));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SingleNotifier>(
          create: (_) => SingleNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
