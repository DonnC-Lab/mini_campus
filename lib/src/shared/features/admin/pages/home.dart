import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/features/admin/pages/add_course.dart';
import 'package:mini_campus/src/shared/index.dart';

import 'add_dept.dart';
import 'add_file.dart';

final adminLoaderProvider = StateProvider((_) => false);

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  routeTo(context, const AdminAddDpt());
                },
                child: const Text('Add Department'),
              ),
              ElevatedButton(
                onPressed: () {
                  routeTo(context, const AdminAddCourse());
                },
                child: const Text('Add Course'),
              ),
              ElevatedButton(
                onPressed: () {
                  routeTo(context, const AdminAddFile());
                },
                child: const Text('Add Resource File'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
