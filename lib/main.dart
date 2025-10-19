import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainning/di/injection_container.dart';
import 'package:trainning/presentation/auth/bloc/auth_bloc.dart';
import 'package:trainning/presentation/bloc/music_bloc.dart';
import 'package:trainning/presentation/auth/login_page.dart';
import 'package:trainning/presentation/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(initFuture: initDependencies()));
}

class MyApp extends StatelessWidget {
  final Future<void> initFuture;
  const MyApp({super.key, required this.initFuture});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Lỗi khởi tạo ứng dụng',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthBloc(
                watchAuthState: sl(),
                signIn: sl(),
                register: sl(),
                signOut: sl(),
              ),
            ),
            BlocProvider(
              create: (_) => MusicBloc(
                getAllMusics: sl(),
                addMusic: sl(),
                updateMusic: sl(),
                deleteMusic: sl(),
                searchMusics: sl(),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Music Manager',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.isAuthenticated) {
                  return const HomePage();
                }
                return const LoginPage();
              },
            ),
          ),
        );
      },
    );
  }
}

