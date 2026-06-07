import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/media.dart';
import 'package:flutter_application_1/profile.dart';

class ColumnPage extends StatefulWidget {
  const ColumnPage({super.key});

  @override
  State<ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<ColumnPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    MediaPage(),
    ProfilePage(),
  ];

  final List<String> pageTitles = const [
    "Movie Dashboard",
    "Movie Collection",
    "My Profile",
  ];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF141414),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE50914),
                    Color(0xFF3D0000),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.movie_filter_rounded,
                      size: 45,
                      color: Color(0xFFE50914),
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Movie Review App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Discover • Review • Rate",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            ListTile(
              leading: Icon(
                Icons.home,
                color: currentIndex == 0
                    ? const Color(0xFFE50914)
                    : Colors.black54,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  fontWeight:
                      currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                  color: currentIndex == 0
                      ? const Color(0xFFE50914)
                      : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                changePage(0);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.movie_creation_outlined,
                color: currentIndex == 1
                    ? const Color(0xFFE50914)
                    : Colors.black54,
              ),
              title: Text(
                "Movies",
                style: TextStyle(
                  fontWeight:
                      currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                  color: currentIndex == 1
                      ? const Color(0xFFE50914)
                      : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                changePage(1);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.person,
                color: currentIndex == 2
                    ? const Color(0xFFE50914)
                    : Colors.black54,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  fontWeight:
                      currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
                  color: currentIndex == 2
                      ? const Color(0xFFE50914)
                      : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                changePage(2);
              },
            ),

            const Spacer(),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/");
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: changePage,
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: const Color(0xFFE50914),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: "Movies",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}