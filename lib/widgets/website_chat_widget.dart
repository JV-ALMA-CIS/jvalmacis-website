// lib/widgets/website_chat_widget.dart
//
// The "Ask ALMA" AI assistant: a compact button fixed to the bottom-right of
// every page, and the chat panel it opens. Conversation state lives in
// chatControllerProvider; replies come from WebsiteChatService.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'website_chat_service.dart';
import '../design/palette.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../providers/chat_provider.dart';

const _suggestions = [
  'What services do you offer?',
  'Tell me about your software platforms',
  'How can I contact you?',
  'Are there any job openings?',
];

/// The button that opens and closes the chat panel. A labelled pill on
/// tablet and desktop, a round icon button on phones.
class WebsiteChatFab extends StatefulWidget {
  const WebsiteChatFab({super.key});

  @override
  State<WebsiteChatFab> createState() => _WebsiteChatFabState();
}

class _WebsiteChatFabState extends State<WebsiteChatFab> {
  OverlayEntry? _panel;

  bool get _open => _panel != null;

  @override
  void dispose() {
    _panel?.remove();
    super.dispose();
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _panel = OverlayEntry(builder: (_) => _ChatOverlay(onClose: _close));
      Overlay.of(context).insert(_panel!);
      setState(() {});
    }
  }

  void _close() {
    _panel?.remove();
    _panel = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final label = _open ? 'Close chat' : 'Ask ALMA, our AI assistant';

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: Palette.ink,
          elevation: 4,
          shadowColor: const Color(0x400B1220),
          shape: const StadiumBorder(),
          child: InkWell(
            onTap: _toggle,
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: compact
                  ? const EdgeInsets.all(16)
                  : const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _open ? LucideIcons.x : LucideIcons.messageCircle,
                    color: Palette.n0,
                    size: 20,
                  ),
                  if (!compact) ...[
                    const SizedBox(width: Space.xs),
                    Text(
                      _open ? 'Close' : 'Ask ALMA',
                      style: AppType.theme.labelLarge?.copyWith(color: Palette.n0),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Positions the panel above the chat button.
class _ChatOverlay extends StatelessWidget {
  const _ChatOverlay({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 600;
    final width = compact ? size.width - 24 : 380.0;
    final height = (size.height - 120).clamp(320.0, 560.0);

    return Positioned(
      right: compact ? 12 : 16,
      // Clear of the chat button (16 margin + 56 button + 12 gap).
      bottom: 84,
      child: SizedBox(
        width: width,
        height: height,
        child: _ChatPanel(onClose: onClose),
      ),
    );
  }
}

class _ChatPanel extends ConsumerStatefulWidget {
  const _ChatPanel({required this.onClose});

  final VoidCallback onClose;

  @override
  ConsumerState<_ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends ConsumerState<_ChatPanel> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final end = _scroll.position.maxScrollExtent;
      if (Motion.reduced(context)) {
        _scroll.jumpTo(end);
      } else {
        _scroll.animateTo(end, duration: Motion.base, curve: Motion.enter);
      }
    });
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || ref.read(chatControllerProvider).isTyping) return;
    _input.clear();
    _focus.requestFocus();
    await ref.read(chatControllerProvider.notifier).send(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatControllerProvider);
    ref.listen(chatControllerProvider, (previous, next) {
      if (previous == null ||
          next.history.length != previous.history.length ||
          next.isTyping != previous.isTyping) {
        _scrollToEnd();
      }
    });

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): widget.onClose},
      child: FocusScope(
        child: Material(
          color: Palette.n0,
          elevation: 12,
          shadowColor: const Color(0x400B1220),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
            side: const BorderSide(color: Palette.n200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _Header(onClose: widget.onClose),
              const Divider(height: 1, thickness: 1, color: Palette.n200),
              Expanded(
                child: chat.history.isEmpty
                    ? _Welcome(onPick: _send)
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(Space.md, Space.md, Space.md, Space.xs),
                        itemCount: chat.history.length + (chat.isTyping ? 1 : 0),
                        itemBuilder: (context, i) => i == chat.history.length
                            ? const _TypingBubble()
                            : _Bubble(message: chat.history[i]),
                      ),
              ),
              _Composer(
                controller: _input,
                focusNode: _focus,
                busy: chat.isTyping,
                onSend: _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.md, Space.sm, Space.xs, Space.sm),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration:
                BoxDecoration(color: Palette.ink, borderRadius: BorderRadius.circular(Radii.sm)),
            child: const Icon(LucideIcons.sparkles, color: Palette.n0, size: 18),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ALMA', style: AppType.theme.titleMedium),
                Text('AI assistant for JV ALMA C.I.S', style: AppType.theme.bodySmall),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Close chat',
            onPressed: onClose,
            icon: const Icon(LucideIcons.x, size: 20, color: Palette.ink),
          ),
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onPick});

  final void Function(String) onPick;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Space.md),
      children: [
        Text('How can I help?', style: AppType.theme.titleLarge),
        const SizedBox(height: Space.xs),
        Text(
          'Ask about our business units, software platforms or how to get in touch. '
          'I am an AI assistant, so for enquiries please use the Contact page.',
          style: AppType.theme.bodySmall,
        ),
        const SizedBox(height: Space.lg),
        Text('SUGGESTED QUESTIONS', style: AppType.eyebrow(Palette.n500)),
        const SizedBox(height: Space.sm),
        for (final s in _suggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.xs),
            child: _Suggestion(text: s, onTap: () => onPick(s)),
          ),
      ],
    );
  }
}

class _Suggestion extends StatelessWidget {
  const _Suggestion({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.n50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.sm),
        side: const BorderSide(color: Palette.n200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.sm),
          child: Row(
            children: [
              Expanded(
                  child: Text(text, style: AppType.theme.bodySmall?.copyWith(color: Palette.ink))),
              const Icon(LucideIcons.arrowRight, size: 14, color: Palette.n500),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final text = isUser ? message.text : cleanAiResponse(message.text);

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xs + 2),
            decoration: BoxDecoration(
              color: isUser ? Palette.primary : Palette.n50,
              border: isUser ? null : Border.all(color: Palette.n200),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(Radii.md),
                topRight: const Radius.circular(Radii.md),
                bottomLeft: Radius.circular(isUser ? Radii.md : 4),
                bottomRight: Radius.circular(isUser ? 4 : Radii.md),
              ),
            ),
            // Selectable so visitors can copy an email address or phone number.
            child: SelectableText(
              text,
              style: AppType.theme.bodySmall?.copyWith(
                color: isUser ? Palette.n0 : Palette.ink,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: Space.sm),
        padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.sm),
        decoration: BoxDecoration(
          color: Palette.n50,
          border: Border.all(color: Palette.n200),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Semantics(label: 'ALMA is typing', child: const _TypingDots()),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.busy,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool busy;
  final void Function(String) onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Space.sm, Space.xs, Space.sm, Space.sm),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.n200))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  enabled: !busy,
                  onSubmitted: onSend,
                  textInputAction: TextInputAction.send,
                  style: AppType.theme.bodySmall?.copyWith(color: Palette.ink),
                  decoration: const InputDecoration(
                    hintText: 'Type your question…',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.sm),
                  ),
                ),
              ),
              const SizedBox(width: Space.xs),
              IconButton.filled(
                tooltip: 'Send',
                onPressed: busy ? null : () => onSend(controller.text),
                style: IconButton.styleFrom(
                  backgroundColor: Palette.primary,
                  disabledBackgroundColor: Palette.n200,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                ),
                icon: const Icon(LucideIcons.send, size: 18, color: Palette.n0),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(
            'AI-generated answers can be wrong. For enquiries, contact support@jvalmacis.co.ke.',
            textAlign: TextAlign.center,
            style: AppType.theme.bodySmall?.copyWith(fontSize: 11, color: Palette.n500),
          ),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          // Each dot brightens in turn.
          final phase = ((_c.value * 3) - i).abs();
          final active = phase < 1 ? 1 - phase : 0.0;
          return Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
            decoration: BoxDecoration(
              color: Color.lerp(Palette.n300, Palette.n600, active),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
