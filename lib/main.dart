import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpandableMenu(),
    );
  }
}

class ExpandableMenu extends StatefulWidget {
  @override
  _ExpandableMenuState createState() => _ExpandableMenuState();
}

class _ExpandableMenuState extends State<ExpandableMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _expandAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      if (isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: GestureDetector(
          onTap: _toggleExpansion,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: isExpanded ? 250 : 60,
            height: isExpanded ? 200 : 60,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(isExpanded ? 20 : 30),
            ),
            child: isExpanded ? _buildExpandedMenu() : _buildMainButton(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return Center(
      child: Icon(Icons.menu, color: Colors.white, size: 30),
    );
  }

  Widget _buildExpandedMenu() {
    return FadeTransition(
      opacity: _expandAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMenuItem(Icons.shopping_cart, "Items in Cart"),
          SizedBox(height: 10),
          _buildMenuItem(Icons.history, "Purchase History"),
          SizedBox(height: 10),
          _buildMenuItem(Icons.settings, "App Settings"),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 20),
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
