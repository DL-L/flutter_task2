import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_task2/echo/app_state.dart';
import 'package:flutter_task2/echo/socket/socket_io.dart';
import 'package:flutter_task2/echo/socket_widget.dart/leave_channel_modal.dart';
import 'package:flutter_task2/echo/socket_widget.dart/listen_to_channel_modal.dart';
import 'package:laravel_echo/laravel_echo.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ActionsView extends StatefulWidget {
  final String broadcaster;

  ActionsView({
    Key? key,
    required this.broadcaster,
  });

  @override
  State<StatefulWidget> createState() => _ActionsView();
}

class _ActionsView extends State<ActionsView> {
  late Echo echo;
  late AppState appState;
  late Function log;
  bool isConnected = false;
  List<String> listeningChannels = [];

  @override
  void initState() {
    super.initState();

    initEcho();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      appState = AppState.of(context);
      log = appState.log;
    });
  }

  @override
  void didUpdateWidget(ActionsView old) {
    super.didUpdateWidget(old);

    if (old.broadcaster == widget.broadcaster) return;

    echo.disconnect();
    initEcho();
  }

  void initEcho() {
    echo = initSocketIOClient();
    (echo.connector.socket as IO.Socket).onConnect((_) {
      log('socket.io connected');
      setState(() => isConnected = true);
    });

    (echo.connector.socket as IO.Socket).onDisconnect((_) {
      log('socket.io disconnected');
      setState(() => isConnected = false);
    });
  }

  void listenToChannel(ChannelType type, String name, String event) {
    dynamic channel;

    if (type == ChannelType.public) {
      channel = echo.channel(name);
    } else if (type == ChannelType.private) {
      channel = echo.private(name);
    } else if (type == ChannelType.presence) {
      channel = echo.join(name).here((users) {
        print(users);
      }).joining((user) {
        print(user);
      }).leaving((user) {
        print(user);
      });
    }

    channel.listen(event, (e) {
      if (e == null) return;

      /**
       * Handle pusher event
       */

      print('event: $e');
      log('event: $e');
    });
  }

  @override
  void dispose() {
    echo.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            isConnected ? 'disconnect' : 'connect',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: ClipOval(
            child: Container(
              color: isConnected ? Colors.green : Colors.red,
              height: 20,
              width: 20,
            ),
          ),
          onTap: () {
            isConnected ? echo.disconnect() : echo.connect();
            print(echo.socketId().toString());
          },
        ),
        ListTile(
          title: Text(
            'listen to channel',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: ClipOval(
            child: Container(
              color: Colors.grey[400],
              height: 20,
              width: 20,
              child: Center(
                child: Text(
                  listeningChannels.length.toString(),
                ),
              ),
            ),
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => Scaffold(
                body: ListenToChannelModal(
                  onListen: (ChannelOptions options) {
                    String channelType =
                        options.channelType.toString().substring(12);

                    log('Listening to $channelType channel: ${options.channelName}');

                    listenToChannel(
                      options.channelType,
                      options.channelName,
                      options.event,
                    );

                    if (!listeningChannels.contains(options.channelName)) {
                      setState(() {
                        listeningChannels.add(options.channelName);
                      });
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            'leave channel',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => LeaveChannelModal(
                listeningChannels: listeningChannels,
                onLeave: (String? channelName) {
                  if (channelName != null) {
                    listeningChannels.remove(channelName);
                    log('Leaving channel: $channelName');
                    echo.leave(channelName);
                  }

                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            'get socket-id',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () => log('socket-id: ${echo.socketId()}'),
        ),
      ],
    );
  }
}
