// general app settings for dev mode
// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart' show kReleaseMode;

// ! be very sure to check these settings before production release

const bool BYPASS_EMAIL_VALIDATION_CHECK = !kReleaseMode;

const bool VALIDATE_STUDENT_EMAIL = kReleaseMode;

const bool USE_EMULATOR = false;
