// Tests for the website chat client: what it sends to /api/chat, and how it
// turns each server response into what the visitor sees.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:jv_alma_cis/widgets/website_chat_service.dart';

final _endpoint = Uri.parse('https://www.jvalmacis.com/api/chat');

ChatMessage _msg(String role, String text) =>
    ChatMessage(role: role, text: text, timestamp: DateTime(2026, 11, 4));

WebsiteChatService _service(MockClientHandler handler) =>
    WebsiteChatService(client: MockClient(handler), endpoint: _endpoint);

void main() {
  test('sends only the question and recent history, never instructions', () async {
    late Map<String, dynamic> sent;
    late Uri url;
    final service = _service((req) async {
      url = req.url;
      sent = jsonDecode(req.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({'reply': 'We work across four business units.'}), 200);
    });

    final reply = await service.sendMessage(
      userMessage: 'What do you do?',
      history: [_msg('user', 'Hello'), _msg('assistant', 'Hi!')],
    );

    expect(reply, 'We work across four business units.');
    expect(url, _endpoint);
    expect(sent.keys.toSet(), {'message', 'history'});
    expect(sent['message'], 'What do you do?');
    expect(sent['history'], [
      {'role': 'user', 'text': 'Hello'},
      {'role': 'assistant', 'text': 'Hi!'},
    ]);
  });

  test('trims history to the 12 most recent turns', () async {
    late List<dynamic> history;
    final service = _service((req) async {
      history = (jsonDecode(req.body) as Map<String, dynamic>)['history'] as List<dynamic>;
      return http.Response(jsonEncode({'reply': 'ok'}), 200);
    });

    await service.sendMessage(
      userMessage: 'q',
      history: [for (var i = 0; i < 20; i++) _msg(i.isEven ? 'user' : 'assistant', 'turn $i')],
    );
    expect(history, hasLength(12));
    expect((history.last as Map)['text'], 'turn 19');
  });

  test('maps server errors to messages the visitor can act on', () async {
    Future<String> replyFor(int status) => _service(
          (_) async => http.Response(jsonEncode({'error': 'x'}), status),
        ).sendMessage(userMessage: 'q', history: const []);

    expect(await replyFor(429), contains('wait a few minutes'));
    expect(await replyFor(400), contains('under 500 characters'));
    expect(await replyFor(503), contains('not available right now'));
    expect(await replyFor(502), contains("couldn't get an answer"));
    for (final status in [429, 503, 502]) {
      expect(await replyFor(status), contains('support@jvalmacis.co.ke'));
    }
  });

  test('a network failure gives a clear message instead of throwing', () async {
    final service = _service((_) async => throw http.ClientException('offline'));
    expect(
      await service.sendMessage(userMessage: 'q', history: const []),
      contains("couldn't connect"),
    );
  });

  test('an empty reply is treated as a failure', () async {
    final service = _service((_) async => http.Response(jsonEncode({'reply': '  '}), 200));
    expect(
      await service.sendMessage(userMessage: 'q', history: const []),
      contains("couldn't get an answer"),
    );
  });
}
