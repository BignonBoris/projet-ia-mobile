import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketTestScreen extends StatefulWidget {
  const SocketTestScreen({super.key});

  @override
  State<SocketTestScreen> createState() => _SocketTestScreenState();
}

class _SocketTestScreenState extends State<SocketTestScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io(
      'http://localhost:8000', // 👉 remplace par ton URL socket (ex: http://192.168.x.x:8000)
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      setState(() {
        _messages.add("✅ Connecté au serveur Socket.IO");
      });
    });

    socket.onDisconnect((_) {
      setState(() {
        _messages.add("❌ Déconnecté du serveur");
      });
    });

    socket.on("server_to_client", (data) {
      print(data);
      setState(() {
        _messages.add("📩 Serveur : $data");
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final message = _controller.text.trim();
    socket.emit("client_to_server", message);
    setState(() {
      _messages.add("🧑‍💻 Moi : $message");
    });
    _controller.clear();
  }

  @override
  void dispose() {
    socket.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Socket.IO")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder:
                    (context, index) => ListTile(title: Text(_messages[index])),
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Écris un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text("Envoyer"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
