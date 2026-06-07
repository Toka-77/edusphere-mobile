import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
import 'home_screen.dart';
import '../logic/chatbot/chatbot_bloc.dart';
import '../logic/chatbot/chatbot_event.dart';
import '../logic/chatbot/chatbot_state.dart';
import '../logic/auth/auth_bloc.dart';
import '../logic/auth/auth_state.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          "Hello! I'm EduSphere AI Assistant 🎓\nI can help you with grades, assignments, timetable, deadlines, academic advice, and more.\nWhat can I help you with today?",
      isUser: false,
    ),
  ];

  static const List<String> _quickReplies = [
    'My GPA',
    'My Schedule',
    'Attendance',
    'Assignments',
    'Help',
  ];

  // Typing dots animation
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty || _isTyping) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    final studentId = authState.user.studentNumericId;
    if (studentId == null) return;

    setState(() {
      _messages.add(_ChatMessage(text: text.trim(), isUser: true));
      _isTyping = true;
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    context.read<ChatbotBloc>().add(
          SendChatMessage(studentId: studentId, message: text.trim()),
        );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.border;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.background;
    final txtColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    // Pull initials from authenticated user
    final authState = context.watch<AuthBloc>().state;
    final initials = authState is AuthAuthenticated
        ? authState.user.initials
        : '??';

    return BlocListener<ChatbotBloc, ChatbotState>(
      listener: (context, state) {
        if (state is ChatbotResponseReceived) {
          setState(() {
            _isTyping = false;
            _messages
                .add(_ChatMessage(text: state.response, isUser: false));
          });
          Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        } else if (state is ChatbotError) {
          setState(() {
            _isTyping = false;
            _messages.add(const _ChatMessage(
              text:
                  '⚠️ Sorry, I couldn\'t reach the AI right now. Please check your connection and try again.',
              isUser: false,
            ));
          });
          Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          leading: IconButton(
            icon: Icon(Icons.menu, color: txtColor),
            onPressed: HomeScreen.openDrawer,
          ),
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.smart_toy_outlined,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: txtColor,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Online • EduSphere AI',
                        style: TextStyle(fontSize: 11, color: txtSec),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: txtColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'clear') {
                  setState(() {
                    _messages.clear();
                    _isTyping = false;
                    _messages.add(const _ChatMessage(
                      text:
                          "Hello! I'm EduSphere AI Assistant 🎓\nHow can I help you today?",
                      isUser: false,
                    ));
                  });
                } else if (v == 'about') {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      backgroundColor: cardColor,
                      title: Text('EduSphere AI',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: txtColor)),
                      content: Text(
                        'EduSphere AI is your personal academic advisor powered by real-time AI.\nAsk about grades, schedule, attendance, course recommendations, and more.',
                        style: TextStyle(color: txtSec, fontSize: 13),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it',
                              style: TextStyle(color: AppTheme.primary)),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'clear',
                  child: Row(children: [
                    Icon(Icons.delete_outline,
                        color: AppTheme.primary, size: 18),
                    SizedBox(width: 10),
                    Text('Clear Chat'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'about',
                  child: Row(children: [
                    Icon(Icons.info_outline, size: 18),
                    SizedBox(width: 10),
                    Text('About AI'),
                  ]),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // ── Chat messages ──────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, i) {
                  if (_isTyping && i == _messages.length) {
                    return _buildTypingBubble(isDark, cardColor, borderColor);
                  }
                  final msg = _messages[i];
                  return _buildBubble(
                      msg, isDark, cardColor, borderColor, initials);
                },
              ),
            ),

            // ── Quick replies ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Questions',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.darkTextSec
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickReplies
                          .map(
                            (q) => Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 6),
                              child: GestureDetector(
                                onTap: () => _send(q),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppTheme.primary
                                            .withValues(alpha: 0.12)
                                        : AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppTheme.primary
                                            .withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    q,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            // ── Input bar ─────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isTyping,
                      onSubmitted: _send,
                      style: TextStyle(
                        color:
                            isDark ? AppTheme.darkText : AppTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: _isTyping
                            ? 'AI is thinking…'
                            : 'Ask me anything about EduSphere...',
                        hintStyle: TextStyle(
                            color: isDark
                                ? AppTheme.darkTextSec
                                : AppTheme.textLight,
                            fontSize: 13),
                        filled: true,
                        fillColor:
                            isDark ? AppTheme.darkBg : AppTheme.background,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                              color: AppTheme.primary, width: 1.5),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                              color: borderColor.withValues(alpha: 0.5)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _isTyping ? null : () => _send(_controller.text),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: _isTyping
                            ? AppTheme.primary.withValues(alpha: 0.4)
                            : AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Animated "AI is typing…" bubble with three bouncing dots.
  Widget _buildTypingBubble(
      bool isDark, Color cardColor, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.smart_toy_outlined,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _dotsController,
              builder: (_, __) {
                final t = _dotsController.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    // Each dot peaks at t = i/3 … (i+1)/3
                    final offset = ((t - i * 0.33) % 1.0).clamp(0.0, 1.0);
                    final scale = 1.0 + 0.5 * (offset < 0.5
                        ? offset * 2
                        : (1.0 - offset) * 2);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppTheme.primary
                                .withValues(alpha: 0.6 + 0.4 * (scale - 1)),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_ChatMessage msg, bool isDark, Color cardColor,
      Color borderColor, String initials) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy_outlined,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: msg.isUser ? AppTheme.primary : cardColor,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight:
                          msg.isUser ? const Radius.circular(4) : null,
                      bottomLeft:
                          !msg.isUser ? const Radius.circular(4) : null,
                    ),
                    border:
                        msg.isUser ? null : Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: msg.isUser
                          ? Colors.white
                          : (isDark
                              ? AppTheme.darkText
                              : AppTheme.textPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppTheme.darkTextSec
                        : AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          if (msg.isUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 17,
              backgroundColor: AppTheme.primaryLight,
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  const _ChatMessage({required this.text, required this.isUser});
}
