import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';

import 'package:tv/manger/language.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/SectionModel.dart';



class allmoive extends StatefulWidget {
  @override
  _allmoiveState createState() => _allmoiveState();
}
class _allmoiveState extends State<allmoive> {
  Language lang = Language.ENGLISH;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SectionModel>>(
        stream: FirebaseManager.shared.getSection(section: Section.Movies),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? section = snapshot.data;
            if (section!.isEmpty) {
              return Center(child: Text(
                "No  added", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: List.generate(section.length, (index) {
                return InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(
                          "/Wrapper"),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12))
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(lang == Language.ARABIC
                          ? section[index].titleAR
                          : section[index].titleEN,
                        style: TextStyle(color: Theme
                            .of(context)
                            .primaryColor, fontSize: 18, fontWeight: FontWeight
                            .w500,),)
                    ],
                  ),
                );
              }),
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }
}
