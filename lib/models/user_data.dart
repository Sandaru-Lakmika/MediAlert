class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();

  String? firstName;
  String? lastName;
  String? gender;
  DateTime? birthDate;
  List<String> goals = [];

  void clear() {
    firstName = null;
    lastName = null;
    gender = null;
    birthDate = null;
    goals.clear();
  }
}
