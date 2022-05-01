import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../services/resource_repo.dart';
import 'add_learning_file_resource.dart';

class LearningHomeView extends ConsumerStatefulWidget {
  const LearningHomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LearningHomeViewState();
}

class _LearningHomeViewState extends ConsumerState<LearningHomeView> {
  String? _selectedPart;

  late Student? studentProfile;

  late Map<String, dynamic> _learningFilter;

  void _setFilter() {
    setState(() {
      _learningFilter = {
        'dptCode': studentProfile!.departmentCode,
        'part': _selectedPart ?? studentProfile!.email.studentNumber.stringYear,
        'category': '',
      };
    });
  }

  @override
  void initState() {
    studentProfile = ref.read(studentProvider)!;
    _setFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontSize: 12,
          color: greyTextShade,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: bluishColor,
        tooltip: 'upload new file',
        onPressed: () {
          routeTo(context, const AddLearningFileResource());
        },
        child: const Icon(MaterialIcons.upload_file),
      ),
      body: studentProfile == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Learning\nManager',
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 28),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: bluishColorShade,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            studentProfile!.departmentCode,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(fontSize: 12),
                          ),
                          DropdownButton<String?>(
                            value: _selectedPart,
                            underline: const SizedBox(),
                            hint: Text('-part-',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                      fontSize: 12,
                                    )),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(fontSize: 12),
                            items: uniParts
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedPart = val;
                              });

                              _setFilter();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ref.watch(resFilterProvider(_learningFilter)).when(
                        data: (items) {
                          final _groupedResources =
                              items.groupBy((res) => res.category);

                          return items.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Text(
                                        "no ${_learningFilter['dptCode']} learning resources found for ${_learningFilter['part']}. You can add your resources",
                                        style: _style),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Recent Files',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 150,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final recentFile = items[index];

                                          return SizedBox(
                                            width: 150,
                                            child: Card(
                                              elevation: 6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    child: Icon(
                                                        FontAwesome.file_pdf_o,
                                                        size: 50),
                                                  ),
                                                  Text(recentFile
                                                      .resource.filename),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      color: bluishColorShade,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Text(
                                                      recentFile.category,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          ?.copyWith(
                                                              fontSize: 10),
                                                    ),
                                                  ),
                                                  // Chip(
                                                  //   label: const
                                                  //   backgroundColor: bluishColorShade,
                                                  //   labelStyle:
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (_, x) =>
                                            const SizedBox(width: 25),
                                        itemCount: items.take(4).length,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Folders',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                    ListView.separated(
                                      padding: const EdgeInsets.all(8),
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          tileColor:
                                              Theme.of(context).cardColor,
                                          title: Text(
                                            _groupedResources.keys
                                                .elementAt(index),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                ?.copyWith(fontSize: 17),
                                          ),
                                          subtitle: Text(_groupedResources[
                                                  _groupedResources.keys
                                                      .elementAt(index)]!
                                              .length
                                              .toString()),
                                          leading: const CircleAvatar(
                                              radius: 35,
                                              child: Icon(MaterialCommunityIcons
                                                  .folder_google_drive)),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 30),
                                      itemCount: _groupedResources.length,
                                    ),
                                  ],
                                );
                        },
                        error: (e, st) => Center(
                            child: Text(
                                '🙁 failed to fetch Learning Resource Items',
                                style: _style)),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                ),
              ],
            ),
    );
  }
}