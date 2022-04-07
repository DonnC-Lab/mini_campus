import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/modules/lost_and_found/data/models/lost_found_item.dart';

final fakeDataProvider = Provider((_) => FakeData());

/// provide all sorts of fake data
class FakeData {
  static final _faker = Faker();

  List<LostFoundItem> get lostFoundItems => List.generate(
        17,
        (index) {
          final _date = _faker.date.dateTime(minYear: 2019, maxYear: 2022);

          return LostFoundItem(
            type: index.isEven ? 'lost' : 'found',
            date: _date,
            month: DateFormat.MMM().format(_date),
            location: 'campus',
            name: _faker.vehicle.make(),
            description: _faker.lorem.sentences(6).toString(),
            uploader: 'admin',
          );
        },
      );
}
