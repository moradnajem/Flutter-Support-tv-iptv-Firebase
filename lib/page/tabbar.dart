import 'package:flutter/material.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/page/profile.dart';
import 'package:tv/section/Section.dart';
import '../main.dart';
import 'User.dart';

import 'favorite.dart';


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
        tabItems.add(TabBarItem(Icons.person, "Profile",  Profile()));
        tabItems.add(TabBarItem(Icons.live_tv, "Live",  SectionScreen(Section.LIVE, "Live")));
        tabItems.add(TabBarItem(Icons.slow_motion_video_rounded, "Movies",  SectionScreen(Section.Movies, "Movies")));
        tabItems.add(TabBarItem(Icons.video_call_sharp, "Series",  SectionScreen(Section.Series, "Series")));
        break;
      case UserType.USER:
        tabItems = [];
        tabItems.add(TabBarItem(Icons.live_tv, "Live",  SectionScreen(Section.LIVE, "Live")));
        tabItems.add(TabBarItem(Icons.slow_motion_video_rounded, "Movies",  SectionScreen(Section.Movies, "Movies")));
        tabItems.add(TabBarItem(Icons.video_call_sharp, "Series",  SectionScreen(Section.Series, "Series")));
        tabItems.add(TabBarItem(Icons.person, "Profile",  Profile()));
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