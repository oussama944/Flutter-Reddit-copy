import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/core/constants/constants.dart';
import 'package:reddit_clone_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_app/theme/palette.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin =true });


void signInWithGoogle(BuildContext context, WidgetRef ref){
  ref.read(
    authControllerProvider.notifier
  ).signInWithGoogle(context,isFromLogin);
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context,ref),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text("Continuer avec google",style: TextStyle(fontSize: 25),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          )
        ),
      ),
    );
  }
}
