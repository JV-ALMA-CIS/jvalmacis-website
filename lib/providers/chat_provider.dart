import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/website_chat_service.dart';

class ChatState {
  final List<ChatMessage> history;
  final bool isTyping;
  final bool showSuggestions;

  const ChatState({
    this.history = const [],
    this.isTyping = false,
    this.showSuggestions = true,
  });

  ChatState copyWith({
    List<ChatMessage>? history,
    bool? isTyping,
    bool? showSuggestions,
  }) {
    return ChatState(
      history: history ?? this.history,
      isTyping: isTyping ?? this.isTyping,
      showSuggestions: showSuggestions ?? this.showSuggestions,
    );
  }
}

final chatServiceProvider = Provider<WebsiteChatService>((ref) {
  return const WebsiteChatService();
});

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatState>((ref) {
  return ChatController(ref.read(chatServiceProvider));
});

class ChatController extends StateNotifier<ChatState> {
  ChatController(this._service) : super(const ChatState());

  final WebsiteChatService _service;

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isTyping) return;

    final historySnapshot = List<ChatMessage>.from(state.history);

    state = state.copyWith(
      showSuggestions: false,
      history: [
        ...state.history,
        ChatMessage(role: 'user', text: trimmed, timestamp: DateTime.now()),
      ],
      isTyping: true,
    );

    final reply = await _service.sendMessage(
      userMessage: trimmed,
      history: historySnapshot,
    );

    final cleanReply = cleanAiResponse(
      reply ?? "I'm having trouble connecting right now. Please email us at support@jvalmacis.co.ke.",
    );

    state = state.copyWith(
      isTyping: false,
      history: [
        ...state.history,
        ChatMessage(role: 'assistant', text: cleanReply, timestamp: DateTime.now()),
      ],
    );
  }
}
