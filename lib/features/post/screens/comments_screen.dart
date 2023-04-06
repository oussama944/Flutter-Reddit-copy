import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/features/models/post_model.dart';
import 'package:reddit_clone_app/features/post/widgets/comment_card.dart';

import '../../../common/error_text.dart';
import '../../../common/loader.dart';
import '../../../common/post_card.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/post_controller.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          text: commentController.text.trim(),
          context: context,
          post: post,
        );

    setState(() {
      commentController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  if (!isGuest)
                    const SizedBox(
                      height: 10,
                    ),
                  if (!isGuest)
                    TextField(
                      onSubmitted: (val) => addComment(data),
                      controller: commentController,
                      decoration: const InputDecoration(
                          hintText: 'Vous en pensez quoi?',
                          filled: true,
                          border: InputBorder.none),
                    ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final comment = data[index];
                                return CommentCard(comment: comment);
                              },
                            ),
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
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
