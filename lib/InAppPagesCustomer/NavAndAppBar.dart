import 'package:civicsphere/InAppPagesCustomer/ActiveWork.dart';
import 'package:civicsphere/InAppPagesCustomer/ChatPage.dart';
import 'package:civicsphere/InAppPagesCustomer/HomePages.dart';
import 'package:civicsphere/InAppPagesCustomer/NewListing.dart';
import 'package:civicsphere/InAppPagesCustomer/ProfilePage.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:flutter/material.dart';

class Navandappbar extends StatefulWidget {
  const Navandappbar({super.key});

  @override
  State<Navandappbar> createState() => _NavandappbarState();
}

class _NavandappbarState extends State<Navandappbar> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B375D), Color(0xFF4D194D), Color(0xFF220440)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'C I V I C S P H E R E',
              style: TextStyle(
                  color: AppColors.navbarcolorbg, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [HomePage(), Activework(), Chatpage(), ProfilePage()],
      ),
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _currentIndex, onItemTapped: _onItemTapped),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.navbarcolorbg,
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(Icons.home, 0),
            _navItem(Icons.work_outline, 1),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => Newlisting()));
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkyellow,
                ),
                child: Icon(Icons.add, size: 45, color: AppColors.darkviolet),
              ),
            ),
            _navItem(Icons.chat_bubble_outline, 2),
            _navItem(Icons.person_rounded, 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    return IconButton(
      icon: selectedIndex == index
          ? ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Color(0xFF7B375D),
                    Color(0xFF351D6C),
                    Color(0xFF220440)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              child: Icon(icon, size: 30, color: Colors.white),
            )
          : Icon(icon, size: 30, color: Colors.grey),
      onPressed: () => onItemTapped(index),
    );
  }
}
