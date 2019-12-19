import 'package:auth_provider/abstract_auth_provider.dart';
import 'package:auth_provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookSignInProvider implements AuthProvider {
  final List<String> scope;
  final FacebookLogin facebookLogin;
  final SessionStorage sessionStorage;

  FacebookSignInProvider({
    @required this.facebookLogin,
    @required this.scope,
    @required this.sessionStorage,
  });

  @override
  Future<bool> cacheSessionData(Map<String, dynamic> sessionData) {
    return sessionStorage.set("sessionData", sessionData);
  }

  @override
  Future<bool> logout() async {
    await facebookLogin.logOut();
    await sessionStorage.clearData();
    return true;
  }

  @override
  Future<Map<String, dynamic>> retrieveSessionData() {
    return sessionStorage.get("sessionData");
  }

  @override
  Future<Map<String, dynamic>> signIn({String id, String password}) async {
    final result = await facebookLogin.logIn(scope);
    Map<String, dynamic> data = {};
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        data = {"auth_token": result.accessToken.token};
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw FacebookSignInCancelledException();
        break;
      case FacebookLoginStatus.error:
        throw Exception(result.errorMessage);
        break;
    }
    return data;
  }

  @override
  Future<Map<String, dynamic>> verifyPassword({String password}) {
    throw UnimplementedError();
  }
}

class FacebookSignInCancelledException implements Exception {}
