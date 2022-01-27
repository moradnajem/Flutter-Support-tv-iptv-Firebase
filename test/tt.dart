import 'package:flutter/material.dart';
import 'package:tv/front/frontlive.dart';
import 'package:tv/front/frontlive.dart';

import '../lib/front/live.dart';




class Front extends StatefulWidget {
  const Front({Key? key}) : super(key: key);

  @override
  _FrontState createState() => _FrontState();
}

class _FrontState extends State<Front> {

  final PageController _pageController = PageController();

  int indexTap = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  Widget appBarTitle = const Text("AppBar Title");
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading:  IconButton(
            icon: Icon(
                Icons.language,
                color: Theme.of(context).canvasColor
            ),
            onPressed: () => Navigator.pushNamed(context, '/SelectLanguage'),
          ),
          centerTitle: true,
          title:appBarTitle,
          actions: <Widget>[

            IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( actionIcon.icon == Icons.search){
                  actionIcon = const Icon(Icons.close);
                  appBarTitle = const TextField(
                    style: TextStyle(
                      color: Colors.white,

                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white)
                    ),
                  );}
                else {
                  actionIcon = const Icon(Icons.search);
                  appBarTitle = const Text("AppBar Title");
                }


              });
            } ,),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              //ProfileScreen
              // ignore: deprecated_member_use
              child:  FlatButton(
                onPressed: () => Navigator.pushNamed(context, '/SignIn'),

                child: Icon(
                    Icons.person_rounded,
                    color: Theme.of(context).canvasColor

                ),),),]
      ),
      body: PageView(
        controller: _pageController,
        children: [
         // frontlive(),
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
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn
          );
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: indexTap == 0 ? Theme.of(context).primaryColor : Colors.black26,), label: "Live"),
          BottomNavigationBarItem(icon: Icon(Icons.home_repair_service_rounded, color: indexTap == 1 ? Theme.of(context).primaryColor : Colors.black26,), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.home_repair_service_rounded, color: indexTap == 2 ? Theme.of(context).primaryColor : Colors.black26,), label: "Series"),
        ],
      ),
    );
  }

}