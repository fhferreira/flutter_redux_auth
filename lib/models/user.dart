class User {
  final String token;
  final String first_name;
  final String last_name;
  final String picture;

  User({this.token, this.first_name, this.last_name, this.picture});

  factory User.fromJson(Map<String, String> json) {
    return User(
      token: json['token']
    );
  }

  factory User.fromJsonData(Map<String, dynamic> json, String _token) {

    return User(
            token: _token,
            first_name: json['user']['userable']['FirstName'],
            last_name: json['user']['userable']['LastName'],
            picture:  json['picture'],
      );
  }
}