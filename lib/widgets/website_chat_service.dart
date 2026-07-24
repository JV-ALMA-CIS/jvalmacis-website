// lib/widgets/website_chat_service.dart
// ignore_for_file: unused_element, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Reuse the same secure backend
const String _baseUrl = "https://askgemini-h5q65xhlnq-uc.a.run.app";

const List<String> _modelPriority = [
  'gemini-2.5-flash-lite',
  'gemini-2.5-flash',
  'gemini-2.5-pro',
];

// ─── Data Model ────────────────────────────────────────────────────────────

class ChatMessage {
  final String role;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toGeminiPart() => {
        'role': role == 'assistant' ? 'model' : 'user',
        'parts': [{'text': text}],
      };
}

// ─── Service ───────────────────────────────────────────────────────────────

class WebsiteChatService {
  const WebsiteChatService();

  static const String _systemPrompt = '''
You are ALMA, the official intelligent assistant for JV ALMA C.I.S... 
// (Keep your full system prompt exactly as it was)
''';

  Future<String?> sendMessage({
    required String userMessage,
    required List<ChatMessage> history,
  }) async {
    // Build prompt the same way as before
    final List<Map<String, dynamic>> contents = [];

    contents.add({
      'role': 'user',
      'parts': [{'text': _systemPrompt}],
    });
    contents.add({
      'role': 'model',
      'parts': [{'text': 'Hello! I\'m ALMA, your assistant at JV ALMA C.I.S. How can I help you today?'}],
    });

    for (final msg in history) {
      contents.add(msg.toGeminiPart());
    }

    contents.add({
      'role': 'user',
      'parts': [{'text': userMessage}],
    });

    // Convert to single prompt string for our backend
    final prompt = _buildPromptFromContents(contents);

    final raw = await _callBackend(prompt);
    return raw?.trim() ?? _fallback();
  }

  String _buildPromptFromContents(List<Map<String, dynamic>> contents) {
    final buffer = StringBuffer();
    for (final turn in contents) {
      final role = turn['role'] == 'model' ? 'ALMA' : 'User';
      final text = (turn['parts'] as List).first['text'] as String;
      buffer.writeln('$role: $text');
    }
    return buffer.toString();
  }

  Future<String?> _callBackend(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      ).timeout(const Duration(seconds: 40));

      if (res.statusCode != 200) {
        print('[WebsiteChatService] Backend error: ${res.statusCode}');
        return null;
      }

      final jsonBody = jsonDecode(res.body);
      final candidates = jsonBody['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) return null;

      final text = candidates[0]['content']?['parts']?[0]?['text'] as String?;
      return text;
    } catch (e) {
      print('[WebsiteChatService] Network error: $e');
      return null;
    }
  }

  String _fallback() =>
      "I'm having trouble connecting right now due to high demand. Please email us at support@jvalmacis.co.ke — we'll get back to you shortly!";
}