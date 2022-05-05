import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

import '../models/feedback_model.dart';

final fdbkProvider = Provider((_) => FeedbackService());

class FeedbackService {
  static final DetaRepository _detaRepository =
      DetaRepository(baseName: DetaBases.feedback);

  Future addFeedback(FeedbackModel data) async {
    try {
      final res = await _detaRepository.addBaseData(data.toMap());

      if (res is DetaRepositoryException) {
        throw res;
      }

      return res;
    }

    // er
    catch (e) {
      debugLogger(e, name: 'addFeedback');
    }

    return null;
  }
}
