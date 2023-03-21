import 'package:flutter/material.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page modérateur '),
      ),
      body: Column(children: [
        ListTile(
          title: const Text('Ajouter un modérateur'),
          onTap: () {},
        )
      ]),
    );
  }
}
