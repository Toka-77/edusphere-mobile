import 'package:flutter/material.dart';

// ── Global locale notifier ──────────────────────────────────────────
final ValueNotifier<String>
    localeNotifier =
    ValueNotifier('en');

// ── Translation maps (matches web i18n.js) ──────────────────────────
// Only UI-facing strings that appear in the Settings + drawer are
// translated here.  Expand as needed by copying keys from i18n.js.

const Map<String,
        Map<String, String>>
    _translations = {
  'en': {
    'dir': 'ltr',
    // Nav / Drawer
    'dashboard': 'Dashboard',
    'attendance': 'Attendance QR',
    'students': 'Student Services',
    'curriculum': 'Curriculum',
    'records': 'Records',
    'admin': 'Admin Panel',
    'aiAssistant': 'AI Assistant',
    'settings': 'Settings',
    'signOut': 'Sign Out',
    'studentPortal':
        'Student Portal',
    'needHelp': 'Need Help? 🎓',
    'contactSupport':
        'Contact EduSphere support',
    'getSupport': 'Get Support',
    // Dashboard
    'welcomeBack': 'Welcome back,',
    'welcomeName': 'Rawda Ayman! 👋',
    'welcomeSub': "Here's what's happening with your classes today.",
    'totalCourses':
        'Total Courses',
    'avgGpa': 'Average GPA',
    'classesToday':
        'Classes Today',
    'pendingTasks':
        'Pending Tasks',
    'todayClasses':
        "Today's Classes",
    'recentGrades':
        'Recent Grades',
    'pendingAssignments':
        'Pending Assignments',
    'viewAll': 'View All',
    'quickActions':
        'Quick Actions',
    // Settings
    'settingsTitle': '⚙️ Settings',
    'settingsSub':
        'Manage your account and preferences',
    'profile': 'Profile',
    'security': 'Security',
    'notifications':
        'Notifications',
    'appearance': 'Appearance',
    'language': 'Language',
    'academic': 'Academic',
    'saveChanges': 'Save Changes',
    'darkMode': 'Dark Mode',
    'lightMode': 'Light Mode',
    'systemSync':
        'Sync with System',
    // Attendance
    'qrAttendance':
        'QR Attendance',
    'smartAttendance':
        'EduSphere Smart Attendance System',
    'scanQr': 'Scan QR Code',
    // Search
    'searchAnything':
        'Search anything...',
    // Extra nav keys
    'logout': 'Sign Out',
    'grades': 'Grades',
    'timetable': 'Timetable',
    'addDrop': 'Add / Drop Courses',
    'services': 'Student Services',
    'adminPanel': 'Admin Panel',
  },
  'ar': {
    'dir': 'rtl',
    'dashboard': 'لوحة القيادة',
    'attendance': 'الحضور الذكي',
    'students': 'خدمات الطلاب',
    'curriculum': 'المنهج الدراسي',
    'records': 'السجلات',
    'admin': 'شؤون الإدارة',
    'aiAssistant': 'المساعد الذكي',
    'settings': 'الإعدادات',
    'signOut': 'تسجيل الخروج',
    'studentPortal':
        'بوابة الطالب',
    'needHelp': 'تحتاج مساعدة؟ 🎓',
    'contactSupport':
        'تواصل مع دعم EduSphere',
    'getSupport':
        'الحصول على الدعم',
    'welcomeBack':
        'مرحباً بعودتك،',
    'welcomeName': 'روضة أيمن! 👋',
    'welcomeSub':
        'إليك ما يحدث في دراستك اليوم.',
    'totalCourses':
        'إجمالي المواد',
    'avgGpa': 'المعدل التراكمي',
    'classesToday':
        'محاضرات اليوم',
    'pendingTasks':
        'المهام المعلقة',
    'todayClasses':
        'محاضرات اليوم',
    'recentGrades':
        'الدرجات الأخيرة',
    'pendingAssignments':
        'التكاليف المعلقة',
    'viewAll': 'عرض الكل',
    'quickActions':
        'إجراءات سريعة',
    'settingsTitle':
        '⚙️ الإعدادات',
    'settingsSub':
        'إدارة حسابك وتفضيلاتك',
    'profile': 'الملف الشخصي',
    'security': 'الأمان',
    'notifications': 'الإشعارات',
    'appearance': 'المظهر',
    'language': 'اللغة',
    'academic': 'أكاديمي',
    'saveChanges': 'حفظ التغييرات',
    'darkMode': 'الوضع الداكن',
    'lightMode': 'الوضع الفاتح',
    'systemSync': 'مزامنة النظام',
    'qrAttendance': 'الحضور الذكي',
    'smartAttendance':
        'نظام الحضور الذكي من EduSphere',
    'scanQr': 'مسح الرمز',
    'searchAnything':
        'ابحث عن أي شيء...',
  },
  'ru': {
    'dir': 'ltr',
    'dashboard': 'Главная',
    'attendance': 'Посещаемость',
    'students': 'Службы',
    'curriculum': 'Программа',
    'records': 'Оценки',
    'admin': 'Админ. персонал',
    'aiAssistant': 'ИИ Помощник',
    'settings': 'Настройки',
    'signOut': 'Выйти',
    'studentPortal':
        'Студенческий Портал',
    'needHelp': 'Нужна Помощь? 🎓',
    'contactSupport':
        'Свяжитесь с поддержкой EduSphere',
    'getSupport':
        'Получить Помощь',
    'welcomeBack':
        'С возвращением,',
    'welcomeName':
        'Равда Айман! 👋',
    'welcomeSub':
        'Вот что сегодня происходит с вашей учебой.',
    'totalCourses': 'Всего Курсов',
    'avgGpa': 'Средний Балл',
    'classesToday':
        'Занятия Сегодня',
    'pendingTasks':
        'Ожидающие Задачи',
    'todayClasses':
        'Занятия Сегодня',
    'recentGrades':
        'Недавние Оценки',
    'pendingAssignments':
        'Ожидающие Задания',
    'viewAll': 'Посмотреть Все',
    'quickActions':
        'Быстрые Действия',
    'settingsTitle':
        '⚙️ Настройки',
    'settingsSub':
        'Управление вашими предпочтениями',
    'profile': 'Профиль',
    'security': 'Безопасность',
    'notifications': 'Уведомления',
    'appearance': 'Внешний Вид',
    'language': 'Язык',
    'academic': 'Академический',
    'saveChanges': 'Сохранить',
    'darkMode': 'Темный Режим',
    'lightMode': 'Светлый Режим',
    'systemSync':
        'Синхр. с Системой',
    'qrAttendance':
        'QR Посещаемость',
    'smartAttendance':
        'Система смарт-посещаемости EduSphere',
    'scanQr': 'Сканировать QR',
    'searchAnything': 'Поиск...',
  },
  'fr': {
    'dir': 'ltr',
    'dashboard': 'Tableau de bord',
    'attendance': 'Présence',
    'students': 'Services',
    'curriculum': 'Programme',
    'records': 'Dossiers',
    'admin': 'Administration',
    'aiAssistant': 'Assistant IA',
    'settings': 'Paramètres',
    'signOut': 'Déconnexion',
    'studentPortal':
        'Portail Étudiant',
    'needHelp':
        "Besoin d'aide ? 🎓",
    'contactSupport':
        'Contacter le support EduSphere',
    'getSupport':
        "Obtenir de l'aide",
    'welcomeBack': 'Bon retour,',
    'welcomeName':
        'Toka Khaled! 👋',
    'welcomeSub':
        "Voici ce qui se passe avec vos études aujourd'hui.",
    'totalCourses': 'Cours Totaux',
    'avgGpa': 'Moyenne Générale',
    'classesToday':
        "Cours Aujourd'hui",
    'pendingTasks':
        'Tâches en Attente',
    'todayClasses':
        "Cours d'Aujourd'hui",
    'recentGrades':
        'Notes Récentes',
    'pendingAssignments':
        'Devoirs en Attente',
    'viewAll': 'Voir Tout',
    'quickActions':
        'Actions Rapides',
    'settingsTitle':
        '⚙️ Paramètres',
    'settingsSub':
        'Gérer votre compte et vos préférences',
    'profile': 'Profil',
    'security': 'Sécurité',
    'notifications':
        'Notifications',
    'appearance': 'Apparence',
    'language': 'Langue',
    'academic': 'Académique',
    'saveChanges': 'Enregistrer',
    'darkMode': 'Mode Sombre',
    'lightMode': 'Mode Clair',
    'systemSync': 'Sync. Système',
    'qrAttendance': 'Présence QR',
    'smartAttendance':
        "Système de présence intelligente d'EduSphere",
    'scanQr': 'Scanner QR',
    'searchAnything':
        'Rechercher...',
  },
  'de': {
    'dir': 'ltr',
    'dashboard': 'Übersicht',
    'attendance': 'Anwesenheit',
    'students': 'Dienste',
    'curriculum': 'Lehrplan',
    'records': 'Aufzeichnungen',
    'admin': 'Verwaltung',
    'aiAssistant': 'KI-Assistent',
    'settings': 'Einstellungen',
    'signOut': 'Abmelden',
    'studentPortal':
        'Studentenportal',
    'needHelp':
        'Hilfe benötigt? 🎓',
    'contactSupport':
        'EduSphere Support kontaktieren',
    'getSupport': 'Hilfe erhalten',
    'welcomeBack':
        'Willkommen zurück,',
    'welcomeName':
        'Toka Khaled! 👋',
    'welcomeSub':
        'Was heute in deinem Studium passiert.',
    'totalCourses': 'Kurse Gesamt',
    'avgGpa': 'Notendurchschnitt',
    'classesToday': 'Kurse Heute',
    'pendingTasks':
        'Offene Aufgaben',
    'todayClasses':
        'Heutige Kurse',
    'recentGrades':
        'Aktuelle Noten',
    'pendingAssignments':
        'Offene Aufgaben',
    'viewAll': 'Alle anzeigen',
    'quickActions':
        'Schnellaktionen',
    'settingsTitle':
        '⚙️ Einstellungen',
    'settingsSub':
        'Konto und Einstellungen verwalten',
    'profile': 'Profil',
    'security': 'Sicherheit',
    'notifications':
        'Benachrichtigungen',
    'appearance': 'Darstellung',
    'language': 'Sprache',
    'academic': 'Akademisch',
    'saveChanges': 'Speichern',
    'darkMode': 'Dunkler Modus',
    'lightMode': 'Heller Modus',
    'systemSync':
        'Systemsynchronisierung',
    'qrAttendance':
        'QR-Anwesenheit',
    'smartAttendance':
        'EduSphere Smart-Anwesenheitssystem',
    'scanQr': 'QR scannen',
    'searchAnything': 'Suchen...',
  },
};

/// Get a translated string by key for the current locale.
String t(String key) {
  final lang =
      localeNotifier.value;
  return _translations[lang]
          ?[key] ??
      _translations['en']?[key] ??
      key;
}

/// Whether the current locale is RTL.
bool get isRtl =>
    t('dir') == 'rtl';
