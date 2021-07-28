import 'dart:async';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      title: "Timer",
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> with TickerProviderStateMixin {
  final player = AudioCache();
  late TabController tb;
  int houre = 0;
  int min = 0;
  int sec = 0;
  String timetodisplay = "";
  bool started = true;
  bool stoped = true;
  int timefortimer = 0;
  bool canceltimer = false;
  

  bool startispressed=true;
  bool stopispressed=true;
  bool resetispressed=true;
  String stoptimetodisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  @override
  void initState() {
    tb = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  void start() {
    setState(() {
      started = false;
      stoped = false;
      canceltimer=false;
    });
    timefortimer = ((houre * 3600) + (min * 60) + sec);
    Timer.periodic(dur, (Timer t) {
      setState(() {
        if (timefortimer < 1 || canceltimer == true) {
          t.cancel();
         
        } else if (timefortimer < 60) {
            if(timefortimer<5&&timefortimer>3){
                  player.play('music/Timer.mp3');
              }
          timetodisplay = timefortimer.toString();
          timefortimer = timefortimer - 1;
        } else if (timefortimer < 3600) {
          int n = timefortimer ~/ 60;
          int s = timefortimer - (60 * n);
          timetodisplay = n.toString() + ":" + s.toString();
          timefortimer = timefortimer - 1;
        } else {
          int h = timefortimer ~/ 3600;
          int t = timefortimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timetodisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timefortimer = timefortimer - 1;
        }
      });
    }
    );
  }

  void stop() {
    setState(() {
      started = true;
      stoped = true;
    });
    canceltimer = true;
  }

  Widget timer() {
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        "HH",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    NumberPicker(
                        value: houre,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (value) {
                          setState(() {
                            houre = value;
                          });
                        }),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        "MM",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    NumberPicker(
                        value: min,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) {
                          setState(() {
                            min = value;
                          });
                        }),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        "SS",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    NumberPicker(
                        value: sec,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) {
                          setState(() {
                            sec = value;
                          });
                        }),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            
            flex: 1,
            child: Text(
              "$timetodisplay",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                   splashColor: Colors.indigo,
                     color: Colors.indigoAccent,
                
                    onPressed: started ? start : null,

                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12.0,
                    ),
                    child: Text(
                      "Start",
                    ),
                  ),
                  FlatButton(
                    splashColor: Colors.green,
                     color: Colors.indigoAccent,
                    onPressed: stoped ? null : stop,
                    child: Text(
                      "Stop",
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }


  void starttimer(){
    Timer(dur, keeprunning);
  }

  
  void keeprunning(){
    if(swatch.isRunning){
      starttimer();
    }
  

    setState(() {
      stoptimetodisplay=swatch.elapsed.inHours.toString().padLeft(2,"0") +":"
                        + (swatch.elapsed.inMinutes%60).toString().padLeft(2,"0") + ":"
                        + (swatch.elapsed.inSeconds%60).toString().padLeft(2,"0");
    });
  }

  void startstopwatch(){
    setState(() {
      stopispressed=false;
      startispressed=false;
    });
    swatch.start();
    starttimer();
  }

  void resetstopwatch(){
    setState(() {
      startispressed=true;
      resetispressed=true;
    });
    swatch.reset();
    stoptimetodisplay = "00:00:00";
  }

  void stopstopwatch(){
    setState(() {
      stopispressed=true;
      resetispressed=false;
    });
    swatch.stop();
  }


  Widget stopwatch(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  stoptimetodisplay,
                  style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
                ),
                
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child:  Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
             children : [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: stopispressed ? null : stopstopwatch,
                    padding: EdgeInsets.all(20),
                    color: Colors.red,
                  child: Text(
                    "Stop",
                      style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                      )
                  ),
                ),
                 RaisedButton(
                  onPressed: resetispressed ? null : resetstopwatch,
                    padding: EdgeInsets.all(20),
                    color: Colors.blue,
                  child: Text(
                    "Reset",
                      style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                      )
                  ),
                ),   
              ],
            ),

            RaisedButton(
                  onPressed: startispressed ?startstopwatch : null ,
                  padding: EdgeInsets.all(20),
                  color: Colors.green,
                  child: Text(
                    "Start",
                      style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                      )
                  ),
                ), 
              ],
            ),
             
            ),
              
          ),
        ],
      ),
    );
}
  @override
  Widget build(BuildContext context) {
    var timer2 = timer();
    var timer22 = timer2;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Timer App",
        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: [
            Text(
              "Timer ",
            ),
            Text(
              "Stopwatch",
            ),
          ],
          labelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: EdgeInsets.all(10.0),
          unselectedLabelColor: Colors.white60,
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: [
          timer(),
         stopwatch(),
        ],
        controller: tb,
      ),
    );
  }
}
