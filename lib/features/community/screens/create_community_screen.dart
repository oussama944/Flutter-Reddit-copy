import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_app/common/loader.dart';
import 'package:reddit_clone_app/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreen();
}

class _CreateCommunityScreen extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    communityNameController.dispose();
    super.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Creer une fete')),
      body: isLoading
          ? const Loader()
          : ListView(padding: const EdgeInsets.all(10.0), children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Text('fff'),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: communityNameController,
                  decoration: const InputDecoration(
                    hintText: 'r/Fete name',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  maxLength: 30,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: communityNameController,
                  decoration: const InputDecoration(
                    hintText: 'r/Fete name',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  maxLength: 30,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    onPressed: createCommunity,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: const Text(
                      'Creer une fete ',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  )),
            ]),
    );
  }
}
