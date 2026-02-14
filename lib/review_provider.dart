import 'package:flutter/material.dart';
import 'review_model.dart';

class ReviewProvider extends ChangeNotifier {
  final List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews => _reviews;

  void addReview(ReviewModel review) {
    _reviews.add(review);
    notifyListeners();
  }
}
