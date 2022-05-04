import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/resource/file_resource.dart';
import 'file_resource_viewer_online.dart';
import 'resource_details_modal.dart';

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
        routeTo(context, FileResourceViewerOnline(fileResource: recentFile));
      },
      child: SizedBox(
        width: 150,
        child: Card(
          elevation: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        child: const Icon(
                          Icons.info,
                          color: greyTextShade,
                        ),
                        onTap: () {
                          ResourceDetailsModal(context, recentFile);
                        },
                      ),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(FontAwesome.file_pdf_o, size: 50),
                    ),
                  ),
                ],
              ),
              Text(recentFile.resource.filename),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      recentFile.category,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 10),
                    ),
                    const VerticalDivider(color: greyTextShade),
                    Text(
                      recentFile.year.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
