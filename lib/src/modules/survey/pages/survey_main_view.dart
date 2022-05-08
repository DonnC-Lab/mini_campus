// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:relative_scale/relative_scale.dart';

import '../data/survey_model.dart';
import '../services/survey_repository.dart';
import 'add_survey_view.dart';
import 'survey_details_modal.dart';

class SurveyMainView extends ConsumerStatefulWidget {
  const SurveyMainView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SurveyMainViewState();
}

class _SurveyMainViewState extends ConsumerState<SurveyMainView> {
  @override
  Widget build(BuildContext context) {
    final api = ref.read(surveyRepoProvider);

    final _style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontSize: 12,
          color: greyTextShade,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: bluishColor,
        tooltip: 'add new Survey',
        onPressed: () {
          routeTo(context, const AddSurveyView());
        },
        child: const Icon(Icons.add),
      ),
      body: RelativeBuilder(builder: (context, height, width, sy, sx) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Surveys',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 28),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<SurveyModel>>(
                future: api.getAllSurveys(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    final surveys = snapshot.data ?? [];

                    return surveys.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.2,
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                      'no surveys found at the moment, check again later!',
                                      style: _style),
                                  const SizedBox(height: 30),
                                  // CustomRoundedButton(
                                  //   text: 'retry',
                                  //   widthRatio: 0.3,
                                  //   onTap: () {
                                  //     setState(() {});
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final survey = surveys[index];

                              return ListTile(
                                onTap: () {
                                  SurveyDetailsModal(
                                    context,
                                    survey,
                                    mode:
                                        ref.watch(themeNotifierProvider).value,
                                  );
                                },
                                leading: const CircleAvatar(
                                  child: Icon(FontAwesome.wpforms),
                                ),
                                title: Text(survey.name),
                                subtitle: Text(
                                  DateFormat.yMMMMd().format(survey.createdOn),
                                ),
                                trailing: StatusContainer(
                                  state:
                                      survey.expireOn.isAfter(DateTime.now()),
                                  deactiveText: 'Expired',
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 30),
                            itemCount: surveys.length,
                          );
                  }

                  //

                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      '🙁 failed to fetch latest surveys',
                      style: _style,
                    ));
                  }

                  //
                  else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
