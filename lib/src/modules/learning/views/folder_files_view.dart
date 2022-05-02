import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../services/resource_repo.dart';
import 'file_resource_card.dart';

class FolderFilesView extends ConsumerWidget {
  const FolderFilesView({Key? key, required this.learningFilter})
      : super(key: key);

  final Map<String, dynamic> learningFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontSize: 12,
          color: greyTextShade,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );

    return Scaffold(
      appBar: AppBar(title: Text(learningFilter['category'])),
      body: Column(
        children: [
          Expanded(
            child: ref.watch(resFilterProvider(learningFilter)).when(
                  data: (items) {
                    return items.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                  "no ${learningFilter['category']} resources found. You can add your resources too from the previous page",
                                  style: _style),
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 20,
                            children: items
                                .map((res) => FileResourceCard(recentFile: res))
                                .toList(),
                          );
                  },
                  error: (e, st) => Center(
                      child: Text(
                    '🙁 failed to fetch ${learningFilter['category']} resources',
                    style: _style,
                  )),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ),
        ],
      ),
    );
  }
}
