import 'package:flutter/material.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(
        channel: HtmlWebSocketChannel.connect("Your websoocket address"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HtmlWebSocketChannel channel;
  MyHomePage({required this.channel});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Socket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                decoration: InputDecoration(labelText: "Send Any Message"),
                controller: editingController,
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text("Connection closed");
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("${snapshot.data}"),
                  );
                } else {
                  return Text("Waiting for data...");
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: _sendMyMessage,
      ),
    );
  }

  void _sendMyMessage() {
    if (editingController.text.isNotEmpty) {
      widget.channel.sink.add(editingController.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close(status.goingAway);
    super.dispose();
  }

}
