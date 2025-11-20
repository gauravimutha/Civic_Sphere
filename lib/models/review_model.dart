class Review {
  final int reviewId;
  final int ratings;
  final String comments;
  final String? image; 
  final int customerId;
  final int workerId;

  Review({
    required this.reviewId,
    required this.ratings,
    required this.comments,
    this.image,
    required this.customerId,
    required this.workerId,
  });

 
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'],
      ratings: json['ratings'],
      comments: json['comments'],
      image: json['image'],
      customerId: json['customer'],
      workerId: json['worker'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'ratings': ratings,
      'comments': comments,
      'image': image,
      'customer': customerId,
      'worker': workerId,
    };
  }
}
