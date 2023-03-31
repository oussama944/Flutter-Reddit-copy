import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/common/error_text.dart';
import 'package:reddit_clone_app/common/loader.dart';
import 'package:reddit_clone_app/features/community/controller/community_controller.dart';
import 'package:reddit_clone_app/features/models/community_model.dart';
import 'package:reddit_clone_app/features/post/controller/post_controller.dart';

import '../../../core/utils.dart';
import '../../../theme/palette.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).sharedImgPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).sharedTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        linkController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty) {
      ref.read(postControllerProvider.notifier).sharedLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Veuillez renseigner tous les champs');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Envoyer ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Partager'),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Entrer votre titre ici',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child:
                                      Icon(Icons.camera_alt_outlined, size: 50),
                                ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entrer votre Description',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      maxLines: 10,
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entrer votre lien',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Selectionner une communoté'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                      data: (data) {
                        communities = data;
                        if (data.isEmpty) {
                          return const SizedBox();
                        }
                        return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            });
                      },
                      error: ((error, stackTrace) => ErrorText(
                            error: error.toString(),
                          )),
                      loading: () => const Loader()),
                ],
              ),
            ),
    );
  }
}
