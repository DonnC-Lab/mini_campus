import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_auth_service.dart';
import 'google_sign_in_service.dart';

final fbAuthProvider = Provider((_) => FirebaseAuthService());

final googleAuthProvider = Provider((_) => GoogleSignInService());
