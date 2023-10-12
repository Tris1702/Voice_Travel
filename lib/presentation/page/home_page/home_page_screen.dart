import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_travel/presentation/page/camera/camera_screen.dart';
import 'package:voice_travel/presentation/page/conversation/conversation_screen.dart';
import 'package:voice_travel/presentation/page/translate_text/translate_text_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static final List<Widget> _widgetOptions = [
    TranslateTextScreen(),
    Camera(),
    ConversationScreen(),
    Text(
      "Index 3: More...",
      style: optionStyle,
    ),
  ];

  static const List<Widget> _widgetTitles = [
    Text(
      "Translate",
      style: optionStyle,
    ),
    Text(
      "Camera",
      style: optionStyle,
    ),
    Text(
      "Conversation",
      style: optionStyle,
    ),
    Text(
      "Setting",
      style: optionStyle,
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: _widgetTitles.elementAt(_selectedIndex)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.language),
            label: "Translate",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.camera),
            label: "Camera",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.comments),
            label: "Conversation",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ellipsis),
            label: "More",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
