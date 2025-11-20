class UserProfile {
  int? id;
  String? email;
  String? name;
  String? role;
  Profile? profile;

  UserProfile({this.id, this.email, this.name, this.role, this.profile});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'profile': profile?.toJson(),
    };
  }
}

class Profile {
  int? id;
  User? user;
  String? skills;
  String? earnings;
  String? status;
  double? averageRating;
  int? totalReviews;

  Profile({
    this.id,
    this.user,
    this.skills,
    this.earnings,
    this.status,
    this.averageRating,
    this.totalReviews,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      skills: json['skills'],
      earnings: json['earnings'],
      status: json['status'],
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      totalReviews: json['total_reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'skills': skills,
      'earnings': earnings,
      'status': status,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
    };
  }
}

class User {
  int? id;
  String? email;
  String? name;
  String? role;

  User({this.id, this.email, this.name, this.role});

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
