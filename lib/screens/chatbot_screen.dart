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
    'My GPA',
    'My Schedule',
    'Attendance',
    'Assignments',
    'Help',
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
    if (lower.contains('hello') || lower.contains('hey')) {
      return "Hello! 👋 Welcome to EduSphere! How can I assist you today?";
    } else if (lower.contains('hi')) {
      return "Hi there! 😊 I'm your EduSphere AI assistant. What would you like to know?";
    } else if (lower.contains('grade') || lower.contains('mark')) {
      return "📊 Your current GPA is 3.82/4.0. You have 4 courses this semester. Would you like details on a specific course?";
    } else if (lower.contains('schedule') || lower.contains('timetable') || lower.contains('class')) {
      return "📅 Your next class is Advanced Web Development (CS431) at 10:00 AM in Room B-204. Check the Timetable for your full schedule.";
    } else if (lower.contains('attend')) {
      return "✅ Your overall attendance rate is 87%. You have 3 pending absences in ENG101. Please submit any medical excuses soon.";
    } else if (lower.contains('help') || lower.contains('what can')) {
      return "I can help you with:\n• 📊 Grades & GPA\n• 📅 Class schedule\n• 📋 Attendance status\n• 📚 Course information\n• 🎓 Graduation requirements\n• 💡 General questions";
    } else if (lower.contains('gpa') || lower.contains('my gpa')) {
      return "🎓 Your current GPA is 3.82/4.0 — Great Standing! You need 45 more credit hours to graduate.";
    } else if (lower.contains('course') || lower.contains('enrolled')) {
      return "📚 This semester you're enrolled in:\n• CS5402 - Advanced Software Engineering\n• CS412 - Database Systems II\n• MATH301 - Discrete Mathematics\n• HUM401 - Professional Ethics";
    } else if (lower.contains('assignment') || lower.contains('homework')) {
      return "📝 You have 2 upcoming assignments:\n• Web Development Project 3 (due tomorrow)\n• Database Lab Report (due in 3 days)";
    } else if (lower.contains('deadline') || lower.contains('due')) {
      return "⏰ Upcoming deadlines:\n• Assignment due: Tomorrow - CS431\n• Lab Report: Dec 15 - CS412\n• Final Submission: Dec 20 - MATH301";
    }
    return "I'm here to help! You can ask me about your courses, grades, schedule, or any academic questions.";
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

    final txtColor = isDark ? AppTheme.darkText : AppTheme.textPrimary;
    final txtSec = isDark ? AppTheme.darkTextSec : AppTheme.textSecondary;

    return Scaffold(
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
          // ⋮ 3-dot menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: txtColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onSelected: (v) {
              if (v == 'clear') {
                setState(() {
                  _messages.clear();
                  _messages.add(const _ChatMessage(
                    text:
                    "Hello! I'm EduSphere AI Assistant 🎓\nHow can I help you today?",
                    isUser: false,
                  ));
                });
              } else if (v == 'export') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat exported to clipboard'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (v == 'about') {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: cardColor,
                    title: Text('EduSphere AI',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: txtColor)),
                    content: Text(
                      'EduSphere AI is your personal academic assistant. Ask about grades, schedule, attendance, and more.',
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
                value: 'export',
                child: Row(children: [
                  Icon(Icons.ios_share_outlined, size: 18),
                  SizedBox(width: 10),
                  Text('Export Chat'),
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

          // Quick replies — always visible (matches web's chatbot-quick always shown)
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
                    color: isDark ? AppTheme.darkTextSec : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _quickReplies
                        .map(
                          (q) => Padding(
                        padding: const EdgeInsets.only(right: 8, bottom: 6),
                        child: GestureDetector(
                          onTap: () => _send(q),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppTheme.primary.withValues(alpha: 0.12)
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
