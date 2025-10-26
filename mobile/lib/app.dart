import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// Core
import 'core/network/dio_client.dart';
import 'presentation/auth/register_page.dart';
// APIs
import 'data/datasources/remote/auth_api.dart';
import 'data/datasources/remote/exam_api.dart';
import 'data/datasources/remote/teacher_api.dart';

// Repositories
import 'data/repositories/auth_repository.dart';
import 'data/repositories/student_repository.dart';
import 'data/repositories/teacher_repository.dart';

// Student UI
import 'presentation/auth/login_page.dart';
import 'presentation/student/student_home_page.dart';
import 'presentation/student/exam_list_page.dart';
import 'presentation/student/exam_detail_page.dart';
import 'presentation/student/exam_result_page.dart';

// Teacher UI
import 'presentation/teacher/teacher_home_page.dart';
import 'presentation/teacher/question_list_page.dart';
import 'presentation/teacher/question_form_page.dart';
import 'presentation/teacher/exam_create_page.dart';
import 'presentation/teacher/exam_assign_page.dart';

// Bloc
import 'state/auth/auth_bloc.dart';
import 'state/auth/auth_event.dart';
import 'state/auth/auth_state.dart';
import 'state/exam/exam_bloc.dart';

class AppRoot extends StatelessWidget {
  AppRoot({super.key});

  // Dio & Repos
  final _dio = DioClient.build();
  late final _authRepo = AuthRepository(AuthApi(_dio));
  late final _studentRepo = StudentRepository(ExamApi(_dio));
  late final _teacherRepo = TeacherRepository(TeacherApi(_dio));

  // GoRouter
  late final _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/splash', builder: (_, __) => const _SplashGate()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),

      // STUDENT
      GoRoute(path: '/student/home', builder: (_, __) => const StudentHomePage()),
      GoRoute(path: '/student/exams', builder: (_, __) => const ExamListPage()),
      GoRoute(
        path: '/student/exam/:id/detail',
        builder: (context, state) {
          final examId = int.parse(state.pathParameters['id']!);
          return ExamDetailPage(examId: examId);
        },
      ),
      GoRoute(
        path: '/student/exam/:id/result',
        builder: (context, state) {
          final score = state.extra as Map<String, dynamic>;
          return ExamResultPage(score: score['score'], total: score['total']);
        },
      ),

      // TEACHER
      GoRoute(path: '/teacher/home', builder: (_, __) => const TeacherHomePage()),
      GoRoute(path: '/teacher/questions', builder: (_, __) => const QuestionListPage()),
      GoRoute(path: '/teacher/questions/new', builder: (_, __) => const QuestionFormPage()),
      GoRoute(
        path: '/teacher/questions/:id',
        builder: (context, state) {
          final q = state.extra;
          return QuestionFormPage(editing: q as dynamic);
        },
      ),
      GoRoute(path: '/teacher/exams/new', builder: (_, __) => const ExamCreatePage()),
      GoRoute(path: '/teacher/exams/assign', builder: (_, __) => const ExamAssignPage()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepo),
        RepositoryProvider.value(value: _studentRepo),
        RepositoryProvider.value(value: _teacherRepo), // ✅ Bổ sung cho Teacher
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(_authRepo)..add(AuthCheckStatus())),
          BlocProvider(create: (_) => ExamBloc(_studentRepo)),
        ],
        child: MaterialApp.router(
          title: 'Quiz 15p',
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFF6E72FC),
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          builder: EasyLoading.init(),
          routerConfig: _router,
        ),
      ),
    );
  }
}

// Splash → chuyển hướng tùy role
class _SplashGate extends StatelessWidget {
  const _SplashGate();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.token != c.token || p.role != c.role,
      listener: (context, state) {
        if (state.token != null && state.role != null) {
          if (state.role!.toUpperCase() == 'TEACHER') {
            GoRouter.of(context).go('/teacher/home');
          } else {
            GoRouter.of(context).go('/student/home');
          }
        } else {
          GoRouter.of(context).go('/login');
        }
      },
      builder: (_, __) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
