import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/features/community/controller/community_controller.dart';
import 'package:reddit_clone_app/features/post/controller/post_controller.dart';
import 'package:reddit_clone_app/features/post/repository/post_repository.dart';
import 'package:reddit_clone_app/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../core/constants/constants.dart';
import '../features/auth/controller/auth_controller.dart';
import '../features/models/post_model.dart';
import 'error_text.dart';
import 'loader.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvote(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).upVote(post, context);
  }

  void downvote(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).downVote(post, context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          post.communityProfilePic),
                                      radius: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.communityName,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            post.username,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                )),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: isGuest
                                        ? () {}
                                        : () => upvote(ref, context),
                                    icon: Icon(
                                      Constants.up,
                                      size: 30,
                                      color: post.upvotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  IconButton(
                                    onPressed: isGuest
                                        ? () {}
                                        : () => downvote(ref, context),
                                    icon: Icon(
                                      Constants.down,
                                      size: 30,
                                      color: post.downvotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ref
                                      .watch(getCommunityByNameProvider(
                                          post.communityName))
                                      .when(
                                        data: (data) {
                                          if (data.mods.contains(user.uid)) {
                                            return IconButton(
                                                onPressed: () =>
                                                    deletePost(ref, context),
                                                icon: const Icon(Icons
                                                    .admin_panel_settings_sharp));
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                        error: (error, stackTrace) =>
                                            ErrorText(error: error.toString()),
                                        loading: () => const Loader(),
                                      ),
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: const Icon(Icons.comment),
                                  ),
                                  Text(
                                    '${post.commentCount == 0 ? 'Svp commenter' : post.commentCount}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  IconButton(
                                    onPressed: isGuest
                                        ? () {}
                                        : () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(30),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4),
                                                    itemCount:
                                                        user.awards.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final award =
                                                          user.awards[index];
                                                      return Image.asset(
                                                          Constants
                                                              .awards[award]!);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                    icon: const Icon(
                                        Icons.card_giftcard_outlined),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
