import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends ConsumerStatefulWidget {
  final int orderId;
  final String targetName;
  final int targetId;

  const ChatScreen({
    super.key,
    required this.orderId,
    required this.targetName,
    required this.targetId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  late IO.Socket socket;
  String? roomId;
  late int myId;

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  Future<void> _connectSocket() async {
    final storage = FlutterSecureStorage();
    final myIdString = await storage.read(key: 'userId');
    if (myIdString != null) {
      myId = int.parse(myIdString);
    }
    final accessToken = await storage.read(key: 'accessToken');

    const prodUrl = 'https://danji.o-r.kr';
    const localWebSocketUrl = 'http://192.168.35.57:3000';

    socket = IO.io(
      prodUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setPath('/chat/socket.io')
          .setExtraHeaders({'authorization': 'Bearer $accessToken'})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Socket connected');
      socket.emit('joinRoom', {'orderId': widget.orderId, 'userId': myId, 'targetId': widget.targetId});
    });

    socket.on('previousMessages', (data) {
      if (!mounted) return;

      print('roomId: ${data['roomId']}');
      final messageList = List<Map<String, dynamic>>.from(data['messages']);

      setState(() {
        roomId = data['roomId'];
        messages = messageList
            .map((m) => {'senderId': int.parse(m['sender'].toString()), 'message': m['content']})
            .toList();
      });
    });

    socket.on('receiveMessage', (data) {
      if (!mounted) return;

      setState(() {
        messages.add({'senderId': int.parse(data['sender'].toString()), 'message': data['content']});
      });
    });

    socket.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    socket.onConnectError((data) => print('⚠️ Connect Error: $data'));

    socket.onError((err) => print('⚠️ Socket error: $err'));
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isEmpty || roomId == null) return;

    socket.emit('sendMessage', {'roomId': roomId, 'content': message});

    setState(() {
      messages.add({'senderId': myId, 'message': message});
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    socket.off('previousMessages');
    socket.off('receiveMessage');
    socket.off('connect');
    socket.off('disconnect');
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(blackTitle: widget.targetName, blueTitle: ''),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMine = msg['senderId'] == myId;
                  return Align(
                    alignment: isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isMine
                            ? const Color(0xFF1E88E5)
                            : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['message'],
                        style: TextStyle(
                          color: isMine ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: '채팅을 입력하세요',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
