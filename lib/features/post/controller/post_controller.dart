import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/core/utils.dart';
import 'package:reddit_clone_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_app/features/post/repository/post_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository-provider.dart';
import '../../models/comment_model.dart';
import '../../models/community_model.dart';
import '../../models/post_model.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      postRepository: postRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final guestPostsProvider =
    StreamProvider((ref,) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts();
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchCommentsOfPost(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void sharedTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postID = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postID,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posté avec succès');
      Routemaster.of(context).pop();
    });
  }

  void sharedLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postID = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postID,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posté avec succès');
      Routemaster.of(context).pop();
    });
  }

  void sharedImgPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postID = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postID,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postID,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        awards: [],
        link: r,
      );
      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posté avec succès');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communitiesList) {
    if (communitiesList.isNotEmpty) {
      return _postRepository.fetchUserPosts(communitiesList);
    }
    return Stream.value([]);
  }

    Stream<List<Post>> fetchGuestPosts() {
      return _postRepository.fetchGuestPosts();
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Le post a bien était supprimé'));
  }

  void upVote(Post post, BuildContext context) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upVote(post, uid);
    showSnackBar(context, '+1');
  }

  void downVote(Post post, BuildContext context) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvotes(post, uid);
    showSnackBar(context, '-1');
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required String text,
    required BuildContext context,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePicture,
    );
    final res = await _postRepository.addComment(comment);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  Stream<List<Comment>> fetchCommentsOfPost(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
