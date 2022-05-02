import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/resource/file_resource.dart';
import 'file_resource_viewer_online.dart';

class FileResourceCard extends StatelessWidget {
  const FileResourceCard({
    Key? key,
    required this.recentFile,
  }) : super(key: key);

  final FileResource recentFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // go to pdf view
        routeTo(context, FileResourceViewerOnline(fileResource: recentFile));
      },
      child: SizedBox(
        width: 150,
        child: Card(
          elevation: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(FontAwesome.file_pdf_o, size: 50),
              ),
              Text(recentFile.resource.filename),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: bluishColorShade,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  recentFile.category,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
