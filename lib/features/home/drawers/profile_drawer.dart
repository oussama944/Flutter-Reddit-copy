import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class ProfilDrawer extends ConsumerWidget {
  const ProfilDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture),
              radius: 70,
            ),
            const SizedBox(height: 20),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              title: const Text('Mon Profile'),
              leading: const Icon(Icons.person),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Se déconnecté'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logOut(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
            )
          ],
        ),
      ),
    );
  }
}
