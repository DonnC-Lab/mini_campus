import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

class MarketProfileView extends ConsumerWidget {
  const MarketProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AdvancedAvatar(
                size: 120,
                decoration: BoxDecoration(
                  color: bluishColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                name: student?.name,
                image: NetworkImage(student?.profilePicture ?? ''),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                student?.alias ?? student?.name ?? 'Student',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cruising beyond imagination',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(fontSize: 13, color: greyTextShade),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
