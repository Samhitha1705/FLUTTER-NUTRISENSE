import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'review_provider.dart';
import 'review_model.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFECE6),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Reviews"),
        centerTitle: true,
      ),

      /// ➕ ADD REVIEW BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController reviewController =
              TextEditingController();
              int selectedRating = 5;

              return AlertDialog(
                title: const Text("Add Review"),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: reviewController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Enter your review",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),

                        /// ⭐ Rating Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                                (index) => IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedRating = index + 1;
                                });
                              },
                              icon: Icon(
                                index < selectedRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      if (reviewController.text.trim().isNotEmpty) {
                        Provider.of<ReviewProvider>(context, listen: false)
                            .addReview(
                          ReviewModel(
                            userName: "User",
                            reviewText: reviewController.text.trim(),
                            rating: selectedRating,
                            date: DateTime.now(),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              );
            },
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 🔹 TITLE
            const Text(
              "What they say about us",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 REVIEWS LIST
            Expanded(
              child: Consumer<ReviewProvider>(
                builder: (context, reviewProvider, child) {
                  final reviews = reviewProvider.reviews;

                  if (reviews.isEmpty) {
                    return const Center(
                      child: Text(
                        "No reviews yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 20),
                        child: ReviewCard(
                          review: reviews[index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 💬 REVIEW CARD
class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// REVIEW TEXT
          Text(
            review.reviewText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 12),

          /// ⭐ DYNAMIC STARS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
                  (index) => Icon(
                index < review.rating
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// USER NAME
          Text(
            "- ${review.userName}",
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
