import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/constants/index.dart';

import '../data/constants/uni_years.dart';

class LearningHomeView extends ConsumerStatefulWidget {
  const LearningHomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LearningHomeViewState();
}

class _LearningHomeViewState extends ConsumerState<LearningHomeView> {
  String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: bluishColor,
        tooltip: 'upload new file',
        onPressed: () {},
        child: const Icon(MaterialIcons.upload_file),
      ),
      body: Column(
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
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    Text(
                      'TCW',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontSize: 12),
                    ),
                    DropdownButton<String?>(
                      value: _selectedYear,
                      underline: const SizedBox(),
                      hint: Text('-year-',
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontSize: 12,
                                  )),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontSize: 12),
                      items: uniYears
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedYear = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recent Files',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 150,
                  child: Card(
                    elevation: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            FontAwesome.file_pdf_o,
                            size: 50,
                          ),
                        ),
                        const Text('TCW5201.pdf'),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: bluishColorShade,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'exam-paper',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(fontSize: 10),
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
              separatorBuilder: (_, x) => const SizedBox(width: 25),
              itemCount: 4,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Folders',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Theme.of(context).cardColor,
                  title: Text(
                    'Videos',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(fontSize: 17),
                  ),
                  subtitle: const Text('17 files'),
                  leading: const CircleAvatar(
                      radius: 35,
                      child: Icon(MaterialCommunityIcons.folder_google_drive)),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 30),
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
