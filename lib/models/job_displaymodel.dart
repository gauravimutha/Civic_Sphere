class Job {
  final int jobId;
  final String? customerName;
  final Worker? worker;
  final String? title;
  final String? description;
  final String? category;
  final String? amount;
  final double? jobLatitude;
  final double? jobLongitude;
  final String? status;
  final String? image;
  final String? timePreference;
  final DateTime? createdAt;
  final int? customer;
  String? locationString;


  Job({
    required this.jobId,
    required this.customerName,
    required this.worker,
    required this.title,
    required this.description,
    required this.category,
    required this.amount,
    this.locationString,
    this.jobLatitude,
    this.jobLongitude,
    required this.status,
    required this.image,
    required this.timePreference,
    required this.createdAt,
    required this.customer,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['job_id'] ?? 0,
      customerName: json['customer_name'],
      worker: json['worker'] != null ? Worker.fromJson(json['worker']) : null,
      title: json['title'],
      description: json['description'],
      category: json['category'],
      amount: json['amount'],
      jobLatitude: json['job_latitude'] != null
          ? double.tryParse(json['job_latitude'].toString())
          : null,
      jobLongitude: json['job_longitude'] != null
          ? double.tryParse(json['job_longitude'].toString())
          : null,
      status: json['status'],
      image: json['image'],
      timePreference: json['time_preference'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      customer: json['customer'],
    );
  }

  get id => null;
}

class Worker {
  final int? id;
  final User? user;
  final String? skills;
  final String? earnings;
  final String? status;
  final double? averageRating;
  final int? totalReviews;

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
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      skills: json['skills'],
      earnings: json['earnings'],
      status: json['status'],
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString())
          : null,
      totalReviews: json['total_reviews'],
    );
  }
}

class User {
  final int? id;
  final String? email;
  final String? name;
  final String? role;

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
}
