class Profile {
  final String name;
  final String description;
  final String username;
  final String email;

  const Profile({
    required this.name,
    required this.description,
    this.username = '',
    this.email = '',
  });

  Profile copyWith({
    String? name,
    String? description,
    String? username,
    String? email,
  }) {
    return Profile(
      name: name ?? this.name,
      description: description ?? this.description,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}
