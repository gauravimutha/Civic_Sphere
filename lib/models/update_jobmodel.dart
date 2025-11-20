class Update {
  final int jobId;
  final String customerName;
  final String? worker;
  final String title;
  final String description;
  final String category;
  final String amount;
  final String jobLatitude;
  final String jobLongitude;
  final String status;
  final String? image;
  final String timePreference;
  final DateTime createdAt;
  final int customer;

  Update({
    required this.jobId,
    required this.customerName,
    this.worker,
    required this.title,
    required this.description,
    required this.category,
    required this.amount,
    required this.jobLatitude,
    required this.jobLongitude,
    required this.status,
    this.image,
    required this.timePreference,
    required this.createdAt,
    required this.customer,
  });

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
      jobId: json['job_id'],
      customerName: json['customer_name'],
      worker: json['worker'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      amount: json['amount'],
      jobLatitude: json['job_latitude'],
      jobLongitude: json['job_longitude'],
      status: json['status'],
      image: json['image'],
      timePreference: json['time_preference'],
      createdAt: DateTime.parse(json['created_at']),
      customer: json['customer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'customer_name': customerName,
      'worker': worker,
      'title': title,
      'description': description,
      'category': category,
      'amount': amount,
      'job_latitude': jobLatitude,
      'job_longitude': jobLongitude,
      'status': status,
      'image': image,
      'time_preference': timePreference,
      'created_at': createdAt.toIso8601String(),
      'customer': customer,
    };
  }
}
