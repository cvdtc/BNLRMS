import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmsmobile/utils/warna.dart';

class Dahsboard extends StatefulWidget {
  const Dahsboard({Key? key}) : super(key: key);

  @override
  _DahsboardState createState() => _DahsboardState();
}

class _DahsboardState extends State<Dahsboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications, color: Colors.black,))
          ],
            elevation: 0,
            backgroundColor: thirdcolor,
            centerTitle: true,
            title: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bnllogodashboard.png'))),
            )),
        body: Column(
          children: [
            Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          color: thirdcolor,
                          padding: EdgeInsets.all(40),
                          constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height /6),
                          child: Column(
                            children: [
                              
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.only(top: 70, left: 20, right: 20),
                          height: 100,
                          width: MediaQuery.of(context).size.width * 2.0,
                          child: Center(
                            child: Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                     Text("90", style: TextStyle(fontSize: 30),),
                                      Text(
                                        " Tugas ",
                                        style: GoogleFonts.inter(
                                            fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                     Text("10", style: TextStyle(fontSize: 30),),
                                      Text(
                                        "Progress",
                                        style: GoogleFonts.inter(
                                            fontSize: 14, color: Colors.blue[800], fontWeight: FontWeight.bold ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
          ],
        ));
  }
}
