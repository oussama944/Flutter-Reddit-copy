import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/error_text.dart';
import '../../../common/loader.dart';
import '../../../common/post_card.dart';
import '../controller/user_profile_controller.dart';

class UserprofilScreen extends ConsumerWidget {
  final String uid;
  const UserprofilScreen({super.key, required this.uid});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profil/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxInScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 250,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(children: [
                          Positioned.fill(
                            child:
                                Image.network(user.banner, fit: BoxFit.cover),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(20).copyWith(bottom: 70),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profilePicture),
                              radius: 50,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () => navigateToEditUser(context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text('Changer le profil'),
                            ),
                          )
                        ]),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${user.karma} karma'),
                              ),
                              const SizedBox(height: 10),
                              const Divider(thickness: 2),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: ref.watch(getUserPostsProvider(uid)).when(
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
                      loading: () => const Loader()),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()));
  }
}
