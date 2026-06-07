import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart';
import 'package:flutter_application_1/movie_data.dart';
import 'package:flutter_application_1/view_data_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedMovieTitle;
  String? selectedRating;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  final List<String> ratingOptions = [
    "5.0",
    "4.5",
    "4.0",
    "3.5",
    "3.0",
    "2.5",
    "2.0",
    "1.5",
    "1.0",
  ];

  @override
  void dispose() {
    nameController.dispose();
    reviewController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    final bool formValid = _formKey.currentState!.validate();

    if (!formValid) {
      return;
    }

    if (selectedMovieTitle == null || selectedRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a movie and rating"),
          backgroundColor: Color(0xFFE50914),
        ),
      );
      return;
    }

    final String reviewerName = nameController.text.trim();
    final String movieTitle = selectedMovieTitle!;
    final String movieRating = selectedRating!;
    final String reviewText = reviewController.text.trim();

    await DatabaseHelper.instance.insertReview(
      reviewerName,
      movieTitle,
      movieRating,
      reviewText,
    );

    for (var movie in movies) {
      if (movie["title"] == movieTitle) {
        movie["review"] = "$reviewerName: $reviewText";
        movie["rating"] = movieRating;
        movie["subtitle"] =
            "${movie["genre"]?.split(' / ').first} • ${movie["year"]} • Rating: $movieRating";
        break;
      }
    }

    if (!mounted) return;

    setState(() {
      selectedMovieTitle = null;
      selectedRating = null;
    });

    nameController.clear();
    reviewController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFFE50914)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Review Submitted",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "Thank you $reviewerName! Your review for '$movieTitle' with a rating of $movieRating/5.0 has been saved.",
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  InputDecoration reviewInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.black38,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFE50914),
        size: 22,
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 42,
        minHeight: 42,
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE50914),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  Widget movieDropdownField() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.movie,
            color: Color(0xFFE50914),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedMovieTitle,
                isExpanded: true,
                dropdownColor: Colors.grey.shade100,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                hint: const Text(
                  "Choose a movie",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 15,
                  ),
                ),
                items: movies.map((movie) {
                  final String movieName = movie["title"] ?? "Unknown Movie";

                  return DropdownMenuItem<String>(
                    value: movieName,
                    child: Text(
                      movieName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMovieTitle = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ratingDropdownField() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Color(0xFFE50914),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedRating,
                isExpanded: true,
                dropdownColor: Colors.grey.shade100,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                hint: const Text(
                  "Give rating",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 15,
                  ),
                ),
                items: ratingOptions.map((rating) {
                  return DropdownMenuItem<String>(
                    value: rating,
                    child: Text(
                      "$rating / 5.0",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRating = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget viewReviewsButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ViewDataPage(),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFFE50914),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "VIEW REVIEWS",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFFE50914),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget submitReviewButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE50914),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "SUBMIT REVIEW",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: const Text(
          "Movie Review",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE50914),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rate_review,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Write a Review",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Share your thoughts about the movie with everyone",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Movie Details",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: reviewInputDecoration(
                          label: "Your Name",
                          hint: "Enter your name",
                          icon: Icons.person,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      movieDropdownField(),
                      const SizedBox(height: 16),
                      ratingDropdownField(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: reviewController,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 4,
                        decoration: reviewInputDecoration(
                          label: "Your Review",
                          hint: "Write your opinion about the movie",
                          icon: Icons.comment,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Review comment cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      viewReviewsButton(),
                      const SizedBox(height: 12),
                      submitReviewButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
