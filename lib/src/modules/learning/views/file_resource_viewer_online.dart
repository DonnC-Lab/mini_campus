import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/resource/file_resource.dart';
import '../services/storage_service.dart';

class FileResourceViewerOnline extends ConsumerWidget {
  FileResourceViewerOnline({Key? key, required this.fileResource})
      : super(key: key);

  final FileResource fileResource;

  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();

  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(learningStorageProvider);

    final _style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontSize: 12,
          color: greyTextShade,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );

    return Scaffold(
      appBar: AppBar(title: Text(fileResource.resource.filename)),
      body: FutureBuilder<File?>(
        future: api.downloadFileResourceFuture(fileResource.resource.filepath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data == null
                ? Center(child: Text('🙁 failed to load file', style: _style))
                : PDF(
                    enableSwipe: true,
                    swipeHorizontal: true,
                    pageFling: true,
                    pageSnap: true,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation: true,
                    onPageChanged: (int? current, int? total) =>
                        _pageCountController.add('${current! + 1} - $total'),
                    onViewCreated: (PDFViewController pdfViewController) async {
                      _pdfViewController.complete(pdfViewController);
                      final int currentPage =
                          await pdfViewController.getCurrentPage() ?? 0;
                      final int? pageCount =
                          await pdfViewController.getPageCount();
                      _pageCountController
                          .add('${currentPage + 1} - $pageCount');
                    },
                  ).fromPath(snapshot.data!.path);
          }

          if (snapshot.hasError) {
            return Center(child: Text('🙁 error loading file', style: _style));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: '<',
                  child: const Text('<'),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! - 1;
                    if (currentPage >= 0) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
                FloatingActionButton(
                  heroTag: '>',
                  child: const Text('>'),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! + 1;
                    final int numberOfPages =
                        await pdfController.getPageCount() ?? 0;
                    if (numberOfPages > currentPage) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
