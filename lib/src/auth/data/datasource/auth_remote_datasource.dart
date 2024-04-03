import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_gallery/core/errors/exceptions.dart';
import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/auth/data/models/user_modal.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<UserModel> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final http.Client _client;
  @override
  Future<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      final response = await _client.post(
        Uri.https('flutter.prominaagency.com', 'api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body) as DataMap;

      if (responseData['error_message'] != null) {
        throw ServerException(
          message: responseData['error_message'],
          statusCode: response.statusCode,
        );
      }

      return UserModel.fromJson(response.body);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}
