import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/common/error_text.dart';
import 'package:reddit_clone_app/common/sign_inbtn.dart';
import 'package:reddit_clone_app/features/community/controller/community_controller.dart';
import 'package:reddit_clone_app/features/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/loader.dart';
import '../../auth/controller/auth_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create_community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          isGuest
              ? const SignInButton()
              : ListTile(
                  title: const Text('Creer une communauté'),
                  leading: const Icon(Icons.add),
                  onTap: (() => navigateToCreateCommunity(context)),
                ),
          if (!isGuest)
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (BuildContext context, int index) {
                          final community = communities[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text(community.name),
                            onTap: () {
                              navigateToCommunity(context, community);
                            },
                          );
                        }),
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                )
        ],
      )),
    );
  }
}
