// Copyright (c) 2022, DonnC Lab
// https://github.com/DonnC-Lab
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:survey/survey.dart';

void main() {
  group('Survey', () {
    test('can be instantiated', () {
      expect(Survey(), isNotNull);
    });
  });
}
