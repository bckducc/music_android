import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainning/di/injection_container.dart';
import 'package:trainning/presentation/auth/bloc/auth_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        watchAuthState: sl(),
        signIn: sl(),
        register: sl(),
        signOut: sl(),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tài khoản')),
        body: Center(
          child: ElevatedButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthSignOutRequested()),
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
          ),
        ),
      ),
    );
  }
}




