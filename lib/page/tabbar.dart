
import 'package:flutter/material.dart';
import 'package:tv/front/home admin.dart';
import 'package:tv/manger/user-type.dart';



import '../main.dart';
import '../front/fron1.dart';


class TabBarItem {

  final IconData icon;
  final String label;
  final Widget page;

  TabBarItem(this.icon, this.label, this.page);

}

class TabBarPage extends StatefulWidget {

  final Object?  userType;

  const TabBarPage({Key? key, this.userType}) : super(key: key);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {

  final PageController _pageController = PageController();

  int indexTap = 0;

  List<TabBarItem> tabItems = [
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch (widget.userType) {
      case UserType.ADMIN:
        tabItems = [];
        tabItems.add(TabBarItem(Icons.home, "Home",  ClientsReport()));
        tabItems.add(TabBarItem(Icons.sticky_note_2_sharp, "Services",  ClientsReport()));
        tabItems.add(TabBarItem(Icons.supervised_user_circle_sharp, "Users",  ClientsReport()));
        break;
      case UserType.USER:
        tabItems = [];
        tabItems.add(TabBarItem(Icons.home, "Home",  uservendor()));
        tabItems.add(TabBarItem(Icons.sticky_note_2_sharp, "my ticket",  uservendor()));
        tabItems.add(TabBarItem(Icons.person, "Profile",  uservendor()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabItems.length,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _getChildrenTabBar(),
          onPageChanged: (index) {
            setState(() {
              indexTap = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          onTap: (index) {
            setState(() {
              indexTap = index;
            });
            _pageController.animateToPage(indexTap,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn
            );
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: indexTap,
          items: _renderTaps(),
        ),
      ),
    );
  }

  List<Widget> _getChildrenTabBar() {

    List<Widget> items = [];

    for (var item in tabItems) {
      items.add(item.page);
    }

    return items;
  }

  List<BottomNavigationBarItem> _renderTaps() {

    List<BottomNavigationBarItem> items = [];

    for (var i = 0; i < tabItems.length; i++) {
      BottomNavigationBarItem obj = BottomNavigationBarItem(icon: Icon(tabItems[i].icon, color: indexTap == i ? Theme.of(context).primaryColor : Colors.black26,), label: AppLocalization.of(context)!.trans(tabItems[i].label));
      items.add(obj);
    }

    return items;

  }

}