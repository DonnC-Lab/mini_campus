import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

class AdminAddFile extends ConsumerStatefulWidget {
  const AdminAddFile({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAddFileState();
}

class _AdminAddFileState extends ConsumerState<AdminAddFile> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    var _detaRepository = DetaRepository(
      driveName: 'lost_found',
    );

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(children: [
            Expanded(
              child: FutureBuilder(
                future: _detaRepository.listFiles(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  }

                  if (snapshot.hasError) {
                    return const Text('err');
                  }

                  //
                  else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
