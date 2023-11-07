class User {
  User({
    required this.id,
    required this.email,
  });
  User.fromJson(String id, Map<String, Object?> json)
      : this(
          id: id,
          email: json['email'] as String,
        );

  final String id;
  final String email;

  Map<String, Object?> toJson() {
    return {
      'email': email,
    };
  }
}
