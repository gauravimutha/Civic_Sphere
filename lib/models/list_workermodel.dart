class UserEarnings {
  final int id;
  final String skills;
  final double earnings;
  final String status;
  final int userId;

  UserEarnings({
    required this.id,
    required this.skills,
    required this.earnings,
    required this.status,
    required this.userId,
  });

  factory UserEarnings.fromJson(Map<String, dynamic> json) {
    return UserEarnings(
      id: json['id'],
      skills: json['skills'] ?? '',
      earnings: double.tryParse(json['earnings'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      userId: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skills': skills,
      'earnings': earnings.toString(),
      'status': status,
      'user': userId,
    };
  }
}
