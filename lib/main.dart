import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CircleMarker cm;
  Polygon pl;

  PolylinePoints polylinePoints = PolylinePoints();
  List<PointLatLng> result;

  List<LatLng> coordinates = [
    LatLng(
      -6.222747,
      106.946948,
    ),
    LatLng(
      -6.222858,
      106.946912,
    ),
    LatLng(
      -6.222873,
      106.946905,
    ),
    LatLng(
      -6.222912,
      106.947074,
    ),
    LatLng(
      -6.222936,
      106.9472,
    ),
    LatLng(
      -6.222952,
      106.94727,
    ),
    LatLng(
      -6.223029,
      106.947582,
    ),
    LatLng(
      -6.223046,
      106.947652,
    )
  ];

  double radius = 200;

  Polyline polyline;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result =
        polylinePoints.decodePolyline("txxzJgwo~jE|EfA\\LlAqIn@{F^kCxCoR`@kC");
    for (var item in result) {
      // coordinates.add(LatLng(item.latitude, item.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  onMapCreated: onMapCreated,
                  onLongPress: onLongPress,
                  onTap: onTap,
                  center: LatLng(-6.22276, 106.94699),
                  zoom: 18,
                  maxZoom: 18),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 10.0,
                      height: 10.0,
                      point: coordinates.first,
                      builder: (ctx) => Container(
                        color: Colors.green,
                      ),
                    ),
                    Marker(
                      width: 10.0,
                      height: 10.0,
                      point: coordinates.last,
                      builder: (ctx) => Container(color: Colors.red),
                    ),
                  ],
                ),
                CircleLayerOptions(
                  circles: [if (cm != null) cm],
                ),
                PolygonLayerOptions(polygons: [
                  if (pl != null && pl.points.length > 3) pl,
                ]),
                PolylineLayerOptions(polylines: [Polyline(points: coordinates)])
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

  void onMapCreated(mapController) {
    pl = Polygon(points: []);
  }

  void onTap(point) {
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
  }

  void onLongPress(point) {
    print(pl.points.length);

    if (pl.points.length > 3) {
      pl.points.clear();
      return;
    }

    setState(() {
      pl.points.add(point);
    });
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = new LatLng(lat / 1E5, lng / 1E5);
      points.add(p);
    }
    return points;
  }
}
