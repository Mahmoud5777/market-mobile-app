class AppUser {
  final String email;
  final String fullName;
  final String role; // "USER" or "ADMIN"

  const AppUser({required this.email, required this.fullName, required this.role});

  bool get isAdmin => role == 'ADMIN';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'] as String,
      fullName: json['fullName'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'fullName': fullName,
        'role': role,
      };
}
