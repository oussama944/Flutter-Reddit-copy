import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/common/error_text.dart';
import 'package:reddit_clone_app/common/loader.dart';
import 'package:reddit_clone_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_app/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/post_card.dart';
import '../../models/community_model.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxInScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(children: [
                      Positioned.fill(
                        child:
                            Image.network(community.banner, fit: BoxFit.cover),
                      )
                    ]),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 35,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                community.name,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              if (!isGuest)
                              community.mods.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        navigateToModTools(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: const Text('Moderer la féte'),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => joinCommunity(
                                          ref, community, context),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? 'Vous participez déja'
                                              : 'Joindre la féte'),
                                    )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('${community.members.length} membres'),
                          )
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: ref.watch(getCommunityProvider(name)).when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = data[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      if (kDebugMode) {
                        print(error.toString());
                      }
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
