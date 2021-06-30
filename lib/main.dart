import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CircleMarker cm;
  Polygon pl;

  double radius = 200;
  // List<LatLng> points;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          if (cm != null)
            Slider(
                min: 100,
                max: 1000,
                divisions: 100,
                label: radius.round().toString(),
                value: radius,
                onChanged: (point) {
                  setState(() {
                    radius = point;
                    final cm1 = CircleMarker(
                      radius: radius,
                      useRadiusInMeter: true,
                      point: cm.point,
                      color: Color.fromARGB(100, 200, 100, 5),
                      borderColor: Colors.black,
                      borderStrokeWidth: 1,
                    );

                    cm = cm1;
                  });
                }),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                onMapCreated: (mapController) {
                  pl = Polygon(points: []);
                },
                onLongPress: (point) {
                  print(pl.points.length);

                  if (pl.points.length > 3) {
                    pl.points.clear();
                    return;
                  }

                  setState(() {
                    pl.points.add(point);
                  });
                },
                onTap: (point) {
                  setState(() {
                    cm = CircleMarker(
                      radius: 400,
                      useRadiusInMeter: true,
                      point: point,
                      color: Color.fromARGB(100, 200, 100, 5),
                      borderColor: Colors.black,
                      borderStrokeWidth: 1,
                    );
                  });
                },
                center: LatLng(51.5, -0.09),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(51.5, -0.09),
                      builder: (ctx) => Container(
                        child: FlutterLogo(),
                      ),
                    ),
                  ],
                ),
                CircleLayerOptions(
                  circles: [if (cm != null) cm],
                ),
                PolygonLayerOptions(polygons: [
                  if (pl != null && pl.points.length > 3) pl,
                ])
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          pl = null;
          cm = null;
        });
      }),
    );
  }
}
