import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart';

class ViewDataPage extends StatefulWidget {
  const ViewDataPage({super.key});

  @override
  State<ViewDataPage> createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  List<Map<String, dynamic>> reviewList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DatabaseHelper.instance.getAllReviews();
    setState(() {
      reviewList = data;
    });
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Delete Review",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this review?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteReview(id);
              Navigator.pop(context);
              loadData();
            },
            child: const Text("Delete",
                style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void showEditDialog(Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['reviewer_name']);
    final reviewController = TextEditingController(text: item['review_text']);
    String selectedRating = item['rating'];

    final List<String> ratingOptions = ["5.0", "4.5", "4.0", "3.5", "3.0", "2.5", "2.0", "1.5", "1.0"];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Edit Review",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Reviewer Name",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE50914))),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRating,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Rating",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54)),
                ),
                items: ratingOptions.map((r) => DropdownMenuItem(
                  value: r,
                  child: Text(r),
                )).toList(),
                onChanged: (value) {
                  selectedRating = value!;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reviewController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Review",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE50914))),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.updateReview(
                item['id'],
                nameController.text,
                item['movie_title'],
                selectedRating,
                reviewController.text,
              );
              Navigator.pop(context);
              loadData();
            },
            child: const Text("Save",
                style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: const Text("Saved Reviews",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: reviewList.isEmpty
          ? const Center(
              child: Text("No reviews yet.",
                  style: TextStyle(color: Colors.white54, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                final item = reviewList[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE50914),
                      child: Icon(Icons.movie, color: Colors.white),
                    ),
                    title: Text(
                      item['movie_title'],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '''Reviewer: ${item['reviewer_name']}
Rating: ${item['rating']} / 5.0
Review: ${item['review_text']}''',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white54),
                          onPressed: () => showEditDialog(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color(0xFFE50914)),
                          onPressed: () => confirmDelete(item['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}