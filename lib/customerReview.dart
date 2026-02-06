import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFECE6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /// 🥗 TOP LEFT FOOD IMAGE
            Positioned(
              top: -10,
              left: -20,
              child: Image.asset(
                'assets/images/healthy_food_1.png',
                height: 160,
              ),
            ),

            /// 🍓 BOTTOM RIGHT FOOD IMAGE
            Positioned(
              bottom: -20,
              right: -20,
              child: Image.asset(
                'assets/images/healthy_food_2.png',
                height: 160,
              ),
            ),

            /// MAIN CONTENT
            Column(
              children: [
                const SizedBox(height: 40),

                /// 🔍 TITLE CHIP (RIGHT SIDE)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "What they say about us",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.search, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔁 REVIEWS (PAGE VIEW)
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: const [
                      ReviewsPageSet(reviews: [
                        "Absolutely loved the healthy meals! Fresh, tasty and perfectly balanced.",
                        "The meal plans helped me stay consistent and healthy.",
                        "Customer support and quality are top-notch!",
                      ]),
                      ReviewsPageSet(reviews: [
                        "Feels like homemade food with nutrition care.",
                        "Perfect app for fitness-focused people.",
                        "Diet plans are easy to follow and effective.",
                      ]),
                      ReviewsPageSet(reviews: [
                        "Great UI and very smooth experience.",
                        "Live coach feature is a game changer!",
                        "Highly recommend for daily wellness.",
                      ]),
                    ],
                  ),
                ),

                /// 🔵 PAGE INDICATOR DOTS
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: _currentPage == index ? 14 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.orange
                              : Colors.orange.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 📄 SINGLE PAGE (3 REVIEWS)
class ReviewsPageSet extends StatelessWidget {
  final List<String> reviews;

  const ReviewsPageSet({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 26),
      itemBuilder: (context, index) {
        return ReviewCard(review: reviews[index]);
      },
    );
  }
}

/// 💬 REVIEW CARD
class ReviewCard extends StatelessWidget {
  final String review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(22, 34, 22, 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            children: [
              Text(
                review,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 14),

              /// ⭐ STARS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                      (index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// ❝ QUOTE ICON
        Positioned(
          top: -20,
          left: 20,
          child: Text(
            "❝",
            style: TextStyle(
              fontSize: 46,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
