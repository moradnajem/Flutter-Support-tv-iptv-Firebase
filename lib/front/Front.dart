import 'package:flutter/material.dart';
import 'package:tv/front/test.dart';


import '2.dart';
import '3.dart';



class Front extends StatefulWidget {
  @override
  _FrontState createState() => _FrontState();
}

class _FrontState extends State<Front> {

  PageController _pageController = PageController();

  int indexTap = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ms"),
          centerTitle: true,
          leading:  IconButton(
          icon: Icon(
          Icons.language,
            color: Theme.of(context).canvasColor
          ),
            onPressed: () => Navigator.pushNamed(context, '/SelectLanguage'),
          ),
          actions: <Widget>[
          Padding(
          padding: EdgeInsets.only(right: 10.0),
          //ProfileScreen
          // ignore: deprecated_member_use
          child:  FlatButton(
          onPressed: () => Navigator.pushNamed(context, '/SignIn'),

          child: Icon(
          Icons.person_rounded,
              color: Theme.of(context).canvasColor

          ),),),]),
        body: PageView(
          controller: _pageController,
          children: [
            frontlive(),
            allmoive(),
            allSeries(),
          ],
          onPageChanged: (index) {
            setState(() {
              indexTap = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) {
            setState(() {
              indexTap = index;
            });
            _pageController.animateToPage(indexTap,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn
            );
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: indexTap == 0 ? Theme.of(context).primaryColor : Colors.black26,), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.home_repair_service_rounded, color: indexTap == 1 ? Theme.of(context).primaryColor : Colors.black26,), label: "Services"),
            BottomNavigationBarItem(icon: Icon(Icons.home_repair_service_rounded, color: indexTap == 2 ? Theme.of(context).primaryColor : Colors.black26,), label: "Services"),
          ],
        ),
      ),
    );
  }

}