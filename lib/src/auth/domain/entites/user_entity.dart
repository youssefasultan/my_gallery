import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
  });

  const UserEntity.empty()
      : this(
          id: 0,
          username: '',
          token: '',
          email: '',
        );

  final int id;
  final String username;
  final String email;
  final String token;

  @override
  List<Object?> get props => [id, username, email, token];

  @override
  String toString() {
    return 'Driver(id: $id , name: $username, '
        ' email: $email, token: $token)';
  }
}
