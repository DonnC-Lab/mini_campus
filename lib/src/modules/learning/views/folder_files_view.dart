import 'package:flutter/material.dart';

final dummyFiles = ['TEE'];

class FolderFilesView extends StatelessWidget {
  const FolderFilesView(
      {Key? key, required this.folder, this.files = const [], this.deptCode})
      : super(key: key);

  final List<String> files;
  final String? deptCode;
  final String folder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folder)),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: const [],
            ),
          ),
        ],
      ),
    );
  }
}
