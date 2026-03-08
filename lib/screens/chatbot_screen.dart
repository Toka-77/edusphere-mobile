import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'home_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          "Hello! I'm EduSphere AI Assistant 🎓\nI can help you with grades, assignments, timetable, deadlines, academic advice, and more.\nWhat can I help you with today?",
      isUser: false,
    ),
  ];

  static const List<String> _quickReplies = [
    'When is my next assignment due?',
    'What are my current grades?',
    'Show my class schedule',
    'How do I improve my GPA?',
    'What services are available?',
  ];

  static final Map<String, String> _responses = {
    'assignment': '📝 Your next assignment is **Web Development Project 3** for CS401, due Dec 15 at 11:59 PM. You have 4 pending assignments in total.',
    'grade': '📊 Your current GPA is **3.61 / 4.0**. You have an A in CS401 (95%), B+ in MATH301 (88%), and A- in ENG201 (92%).',
    'schedule': '📅 Today\'s classes:\n• 09:00 AM — Advanced Web Dev (Tech Building 201)\n• 11:00 AM — Database Systems (Tech Building 305)\n• 02:00 PM — Machine Learning (AI Lab 401)',
    'gpa': '💡 Tips to improve your GPA:\n1. Attend all classes and review notes regularly\n2. Submit assignments early\n3. Use office hours with professors\n4. Form study groups with classmates',
    'service': '🛎️ Available services:\n• Medical Excuses\n• Complaints\n• Academic Warnings\n• Official Requests\nGo to Student Services to access them all.',
    'default': "I understand you're asking about that. Let me help! For detailed information, please check the relevant section of EduSphere or contact your academic advisor. Is there anything more specific I can assist you with?",
  };

  String _getResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('assignment') || lower.contains('due') || lower.contains('deadline')) {
      return _responses['assignment']!;
    } else if (lower.contains('grade') || lower.contains('gpa') && lower.contains('current')) {
      return _responses['grade']!;
    } else if (lower.contains('schedule') || lower.contains('class') || lower.contains('timetable')) {
      return _responses['schedule']!;
    } else if (lower.contains('gpa') || lower.contains('improve') || lower.contains('better')) {
      return _responses['gpa']!;
    } else if (lower.contains('service') || lower.contains('medical') || lower.contains('request')) {
      return _responses['service']!;
    }
    return _responses['default']!;
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text.trim(), isUser: true));
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(text: _getResponse(text), isUser: false));
      });
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
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
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCard : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.border;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.background;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? AppTheme.darkText : AppTheme.textPrimary),
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
              child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
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
                    color: isDark ? AppTheme.darkText : AppTheme.textPrimary,
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
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                return _buildBubble(msg, isDark, cardColor, borderColor);
              },
            ),
          ),

          // Quick replies
          if (_messages.length == 1)
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Questions',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickReplies
                        .map(
                          (q) => GestureDetector(
                            onTap: () => _send(q),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppTheme.primary.withValues(alpha: 0.3)),
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
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),

          // Input bar
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
                    onSubmitted: _send,
                    style: TextStyle(
                      color: isDark ? AppTheme.darkText : AppTheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask me anything about EduSphere...',
                      hintStyle: TextStyle(
                          color: isDark ? AppTheme.darkTextSec : AppTheme.textLight,
                          fontSize: 13),
                      filled: true,
                      fillColor: isDark
                          ? AppTheme.darkBg
                          : AppTheme.background,
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
                        borderSide:
                            const BorderSide(color: AppTheme.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _send(_controller.text),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
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
    );
  }

  Widget _buildBubble(
      _ChatMessage msg, bool isDark, Color cardColor, Color borderColor) {
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
                    color: msg.isUser
                        ? AppTheme.primary
                        : cardColor,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight:
                          msg.isUser ? const Radius.circular(4) : null,
                      bottomLeft:
                          !msg.isUser ? const Radius.circular(4) : null,
                    ),
                    border: msg.isUser
                        ? null
                        : Border.all(color: borderColor),
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
            const CircleAvatar(
              radius: 17,
              backgroundColor: AppTheme.primaryLight,
              child: Text(
                'RA',
                style: TextStyle(
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
