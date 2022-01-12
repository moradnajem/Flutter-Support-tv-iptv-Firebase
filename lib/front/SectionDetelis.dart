import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user_profile.dart';


class SectionDetelis extends StatefulWidget {

  final String udidService;

  const SectionDetelis({Key? key,  required this.udidService}) : super(key: key);

  @override
  _SectionDetelisState createState() => _SectionDetelisState();
}

class _SectionDetelisState extends State<SectionDetelis> {
  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
              return Scaffold(
              body: StreamBuilder<SectionModel>(
                  stream: FirebaseManager.shared.getSectionById(id: widget.udidService),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      SectionModel? service = snapshot.data;
                      return CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back),
                              tooltip: "Back",
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            actions: [
                            //  Visibility(visible: user.userType == UserType.TECHNICIAN, child: IconButton(icon: Icon(Icons.edit, color: Colors.white,), tooltip: AppLocalization.of(context).translate("Edit Service"), onPressed: () => Navigator.of(context).pushNamed("/ServiceForm", arguments: widget.udidService))),
                            ],
                            expandedHeight: MediaQuery.of(context).size.height * (350 / 812),
                            floating: true,
                            pinned: true,
                            snap: true,
                            elevation: 5,
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: Text(lang == Language.ARABIC ? service!.titleAR : service!.titleEN,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  )),
                            //  background: _renderSlider(context, images: service.images),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Info:-", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22, fontWeight: FontWeight.w500),),
                                  //  SizedBox(height: 10),
                                    Text(lang == Language.ARABIC ? service.titleAR : service.titleEN, style: TextStyle(color: Colors.blueGrey, fontSize: 18, height: 1.8,),),
                                //    SizedBox(height: 35),
                                 //   Visibility(visible: user.userType == UserType.USER, child: BtnMain(title: AppLocalization.of(context).translate("Order Service"), onTap: () => Navigator.of(context).pushNamed("/AppointmentBooking", arguments: widget.udidService))),
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: loader(context));
                    }
                  }
              ),
            );
          }
  //        return SizedBox();
        }



