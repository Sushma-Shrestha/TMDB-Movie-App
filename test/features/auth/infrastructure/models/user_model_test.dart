import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/auth/auth.dart';

void main() {
  const rawUserData = {
    'email': 'sushma@gmail.com',
    'userId': 'fy779vhj',
    'emailVerified': false,
  };
  const userDataObject = UserModel(
    email: 'sushma@gmail.com',
    userId: 'fy779vhj',
    emailVerified: false,
  );
  group(
    'Test for user info model',
    () {
      test(
        'can parse data to  user model fromJson',
        () async {
          expect(
            UserModel.fromJson(rawUserData),
            equals(userDataObject),
          );
        },
      );
      test('can convert user data model toJson', () {
        expect(userDataObject.toJson(), rawUserData);
      });
    },
  );
}
