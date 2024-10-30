class UserData {
  String id;
  String firstName;
  String lastName;
  String email;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class ProfileData {
  String id;
  String parentId;
  String name;
  String age;
  String avatar;
  String pin;

  ProfileData({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    required this.avatar,
    required this.pin,
  });
}

String id = "";
String lessonid = "";
String LastActivity = "1";

int age = 0;
