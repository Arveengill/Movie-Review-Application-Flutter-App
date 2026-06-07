import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Global key to manage and validate the text fields form state
  final _formKey = GlobalKey<FormState>();

  // Stored state variables for editable values
  String name = "Arveen Gill";
  String email = "arveengill359@gmail.com";
  String favoriteGenre = "Action, Sci-Fi and Thriller Movies";

  // List of available genre options for selection
  final List<String> availableGenres = [
    "Action",
    "Comedy",
    "Drama",
    "Horror",
    "Romance",
    "Sci-Fi",
    "Thriller"
  ];

  // Tracker for selected options in the editor state
  List<String> selectedGenres = ["Action", "Sci-Fi", "Thriller"];

  // Controllers to handle text input in fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text fields with current values
    nameController.text = name;
    emailController.text = email;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Helper method to trigger a multi-select checkbox menu overlay
  void showGenreSelectionDialog(StateSetter dialogSetState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // We wrap the dialog content inside a StatefulBuilder so the checkboxes can refresh instantly on tap
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetStateInner) {
            return AlertDialog(
              backgroundColor: const Color(0xFF262626),
              title: const Text(
                "Select Genres",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: availableGenres.map((genre) {
                    final isSelected = selectedGenres.contains(genre);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(genre, style: const TextStyle(color: Colors.white)),
                      activeColor: const Color(0xFFE50914),
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? checked) {
                        // FIX: Use dialogSetStateInner to force the checkbox to render the tick marks instantly
                        dialogSetStateInner(() {
                          if (checked == true) {
                            if (!selectedGenres.contains(genre)) {
                              selectedGenres.add(genre);
                            }
                          } else {
                            selectedGenres.remove(genre);
                          }
                        });

                        // This keeps the underlying edit form text synchronized in the background
                        dialogSetState(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to show editing pop-up input form
  void showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text(
                "Edit Profile Info",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey, // Enforces error checking inside fields
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                        // Email structural requirement evaluation
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email cannot be empty";
                          }
                          
                          // Verifies structured email layout standard before '@' and finishes with '.com'
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+com$');
                          
                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Favourite Genres",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown simulation block button targeting selection overlay
                      InkWell(
                        onTap: () => showGenreSelectionDialog(dialogSetState),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white24, width: 1.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedGenres.isEmpty
                                      ? "Select your favorite genres"
                                      : selectedGenres.join(", "),
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: Colors.white70),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Revert text inputs back to verified current values if discarded
                    nameController.text = name;
                    emailController.text = email;
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Only apply data modifications if the form conditions are fulfilled
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        name = nameController.text;
                        email = emailController.text;
                        // Join array values into formatting string format automatically
                        favoriteGenre = selectedGenres.isEmpty
                            ? "No genres selected"
                            : "${selectedGenres.join(', ')} Movies";
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profile updated successfully"),
                          backgroundColor: Color(0xFFE50914),
                        ),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget profileInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE50914),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F0F),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE50914),
                    Color(0xFF3D0000),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFFE50914),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name, // Dynamic variable assignment
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Movie Review App User",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            profileInfoCard(
              icon: Icons.email,
              title: "Email",
              subtitle: email, // Dynamic variable assignment
            ),

            profileInfoCard(
              icon: Icons.school,
              title: "Course",
              subtitle: "Mobile and Ubiquitous Computing",
            ),

            profileInfoCard(
              icon: Icons.movie,
              title: "Favourite Genre",
              subtitle: favoriteGenre, // Dynamic variable assignment
            ),

            profileInfoCard(
              icon: Icons.rate_review,
              title: "Total Reviews",
              subtitle: "15 movie reviews submitted",
            ),

            profileInfoCard(
              icon: Icons.star,
              title: "Average Rating",
              subtitle: "4.8 out of 5 stars",
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: showEditDialog, // Connects directly to dialog function
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(
                    color: Colors.redAccent,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}