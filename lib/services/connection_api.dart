import 'package:http/http.dart' as http;

class ConnectionApi {
  final client = http.Client();

  Future<String> connect() async {
    Uri url = Uri.http('http://localhost:8000');

    var response = await client.post(url, body: {'file64': '', 'content': {}});

    return response.body;
  }
}
