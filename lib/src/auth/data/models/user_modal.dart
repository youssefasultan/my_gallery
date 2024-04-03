import 'dart:convert';

import 'package:my_gallery/core/utils/typedefs.dart';
import 'package:my_gallery/src/auth/domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.token,
  });

  UserModel.fromMap(DataMap map)
      : this(
          id: map['user']['id'] as int,
          username: map['user']['name'] as String,
          email: map['user']['email'] as String,
          token: map['token'] as String,
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  const UserModel.empty()
      : this(
          id: 0,
          email: '',
          username: '',
          token: '',
        );

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  DataMap toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'token': token,
      };

  String toJson() => jsonEncode(toMap());
}
