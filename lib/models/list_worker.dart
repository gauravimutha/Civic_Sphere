class Worker {
  final int id;
  final User user;
  final String skills;
  final String earnings;
  final String status;
  final double averageRating;
  final int totalReviews;

  Worker({
    required this.id,
    required this.user,
    required this.skills,
    required this.earnings,
    required this.status,
    required this.averageRating,
    required this.totalReviews,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      user: User.fromJson(json['user']),
      skills: json['skills'] ?? '',
      earnings: json['earnings'] ?? '0.00',
      status: json['status'] ?? '',
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'skills': skills,
      'earnings': earnings,
      'status': status,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
    };
  }
}

class User {
  final int id;
  final String email;
  final String name;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
