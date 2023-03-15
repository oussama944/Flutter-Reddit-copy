import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/common/loader.dart';
import 'package:reddit_clone_app/core/constants/constants.dart';
import 'package:reddit_clone_app/features/auth/controller/auth_controller.dart';

import '../../../common/sign_inbtn.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Ignorer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Que la fete commence',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  Constants.loginEmotePath,
                  height: 400,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SignInButton(),
            ]),
    );
  }
}