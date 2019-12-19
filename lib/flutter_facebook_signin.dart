library flutter_facebook_signin;

import 'package:auth_provider/abstract_auth_provider.dart';
import 'package:auth_provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'facebook_sign_in_provider_impl.dart';

AuthProvider authProvider;

AuthProvider facebookSignInProvider({
  @required List<String> scopes,
  SessionStorage sessionStorage,
}) {
  assert(scopes != null && scopes.isNotEmpty);
  authProvider ??= FacebookSignInProvider(
    facebookLogin: FacebookLogin(),
    sessionStorage: sessionStorage ?? defaultSessionStorage,
    scope: scopes,
  );
  return authProvider;
}
