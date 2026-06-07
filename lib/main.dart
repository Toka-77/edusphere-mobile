import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'locale_provider.dart';

// Core & Logic imports
import 'core/network/dio_client.dart';
import 'data/services/auth_service.dart';
import 'data/services/dashboard_service.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_event.dart';
import 'logic/auth/auth_state.dart';
import 'logic/dashboard/dashboard_bloc.dart';
import 'data/services/grade_service.dart';
import 'logic/grade/grade_bloc.dart';
import 'data/services/registration_service.dart';
import 'logic/registration/registration_bloc.dart';
import 'data/services/timetable_service.dart';
import 'logic/timetable/timetable_bloc.dart';
import 'data/services/medical_excuse_service.dart';
import 'data/services/complaint_service.dart';
import 'data/services/official_request_service.dart';
import 'data/services/curriculum_service.dart';
import 'logic/curriculum/curriculum_bloc.dart';
import 'data/services/chatbot_service.dart';
import 'logic/chatbot/chatbot_bloc.dart';
import 'data/services/attendance_service.dart';
import 'logic/attendance/attendance_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Core Services
  final dioClient = DioClient();
  final authService = AuthService(dioClient);
  final dashboardService = DashboardService(dioClient);
  final gradeService = GradeService(dioClient);
  final registrationService = RegistrationService(dioClient);
  final timetableService = TimetableService(dioClient);
  final medicalExcuseService = MedicalExcuseService(dioClient);
  final complaintService = ComplaintService(dioClient);
  final officialRequestService = OfficialRequestService(dioClient);
  final curriculumService = CurriculumService(dioClient);
  final chatbotService = ChatbotService(dioClient);
  final attendanceService = AttendanceService(dioClient);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: dioClient),
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: dashboardService),
        RepositoryProvider.value(value: gradeService),
        RepositoryProvider.value(value: registrationService),
        RepositoryProvider.value(value: timetableService),
        RepositoryProvider.value(value: medicalExcuseService),
        RepositoryProvider.value(value: complaintService),
        RepositoryProvider.value(value: officialRequestService),
        RepositoryProvider.value(value: curriculumService),
        RepositoryProvider.value(value: chatbotService),
        RepositoryProvider.value(value: attendanceService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authService: context.read<AuthService>(),
            )..add(AppStarted()),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              dashboardService: context.read<DashboardService>(),
            ),
          ),
          BlocProvider<GradeBloc>(
            create: (context) => GradeBloc(
              context.read<GradeService>(),
            ),
          ),
          BlocProvider<RegistrationBloc>(
            create: (context) => RegistrationBloc(
              context.read<RegistrationService>(),
            ),
          ),
          BlocProvider<TimetableBloc>(
            create: (context) => TimetableBloc(
              context.read<TimetableService>(),
            ),
          ),
          BlocProvider<CurriculumBloc>(
            create: (context) => CurriculumBloc(
              context.read<CurriculumService>(),
            ),
          ),
          BlocProvider<ChatbotBloc>(
            create: (context) => ChatbotBloc(
              chatbotService: context.read<ChatbotService>(),
            ),
          ),
          BlocProvider<AttendanceBloc>(
            create: (context) => AttendanceBloc(
              attendanceService: context.read<AttendanceService>(),
            ),
          ),
        ],
        child: const EduSphereApp(),
      ),
    ),
  );
}

class EduSphereApp extends StatelessWidget {
  const EduSphereApp({super.key});

  static final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: localeNotifier,
          builder: (context, lang, _) {
            return MaterialApp(
              title: 'EduSphere',
              navigatorKey: _navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              // builder wraps ALL routes — persists through pushAndRemoveUntil
              builder: (context, child) {
                return BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      _navigatorKey.currentState?.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      );
                    } else if (state is AuthUnauthenticated) {
                      _navigatorKey.currentState?.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (_) => false,
                      );
                    }
                  },
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
