class OfferModel {
  final int id;
  final String workerName;
  final String jobTitle;
  final String message;
  final double proposedAmount; 
  final DateTime createdAt;
  final int job;
  final int worker;

  OfferModel({
    required this.id,
    required this.workerName,
    required this.jobTitle,
    required this.message,
    required this.proposedAmount,
    required this.createdAt,
    required this.job,
    required this.worker,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      workerName: json['worker_name'],
      jobTitle: json['job_title'],
      message: json['message'],
      proposedAmount: double.tryParse(json['proposed_amount'].toString()) ?? 0.0, 
      createdAt: DateTime.parse(json['created_at']),
      job: json['job'],
      worker: json['worker'],
    );
  }
}