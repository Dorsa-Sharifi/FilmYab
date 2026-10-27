class UserAccount {
  const UserAccount({
    required this.name,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.bio = '',
    this.role = 'user',
  });
  final String name;
  final String username;
  final String email;
  final String passwordHash;
  final String bio;
  final String role;

  bool get isAdmin => role == 'admin';

  UserAccount copyWith({
    String? name,
    String? username,
    String? email,
    String? passwordHash,
    String? bio,
    String? role,
  }) => UserAccount(
    name: name ?? this.name,
    username: username ?? this.username,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    bio: bio ?? this.bio,
    role: role ?? this.role,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'email': email,
    'passwordHash': passwordHash,
    'bio': bio,
    'role': role,
  };
  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
    name: json['name'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    passwordHash: json['passwordHash'] as String,
    bio: json['bio'] as String? ?? '',
    role: json['role'] as String? ?? 'user',
  );
}
