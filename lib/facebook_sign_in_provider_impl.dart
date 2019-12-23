import 'dart:convert';

import 'package:auth_provider/abstract_auth_provider.dart';
import 'package:auth_provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class FacebookSignInProvider implements AuthProvider {
  final List<String> scope;
  final FacebookLogin facebookLogin;
  final SessionStorage sessionStorage;
  final http.Client httpClient;

  FacebookSignInProvider({
    @required this.facebookLogin,
    @required this.scope,
    @required this.sessionStorage,
    @required this.httpClient,
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

  @override
  Future<bool> isSessionActive() async {
    final sessionData = await retrieveSessionData();
    return sessionData != null;
  }

  @override
  Future<Map<String, dynamic>> fetchAdditionalData({
    Map<String, dynamic> authToken,
    List<String> fields = const ['name', 'first_name', 'last_name', 'email'],
  }) async {
    assert(authToken != null && authToken.isNotEmpty);
    assert(fields != null && fields.isNotEmpty);
    final token = authToken['auth_token'];
    final graphResponse = await httpClient.get(
      'https://graph.facebook.com/v2.12/me?fields=${fields.join(',')}&access_token=$token',
    );
    return jsonDecode(graphResponse.body);
  }

  @override
  Future<Map<String, dynamic>> signUp({Map<String, dynamic> data}) {
    throw UnimplementedError();
  }
}

class FacebookSignInCancelledException implements Exception {}
