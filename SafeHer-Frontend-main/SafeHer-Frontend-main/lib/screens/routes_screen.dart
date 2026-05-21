// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../widgets/common_widgets.dart';

// class RoutesScreen extends StatelessWidget {
//   const RoutesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBg,
//       body: SafeArea(
//         child: Column(children: [
//           const PageHeader(title: 'Safe Routes'),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 _buildInputCard(),
//                 const SizedBox(height: 16),
//                 _buildRoutePreview(),
//                 const SizedBox(height: 20),
//                 const Text('Suggested Routes', style: kTitle),
//                 const SizedBox(height: 12),
//                 _SafestRouteCard(
//                   name: 'Via Main Street',
//                   time: '12 min',
//                   distance: '1.2 km',
//                   safetyPct: 92,
//                   tags: const ['Well-lit', 'CCTV'],
//                 ),
//                 const SizedBox(height: 12),
//                 _RouteCard(
//                   name: 'Via Park Avenue',
//                   time: '15 min',
//                   distance: '1.5 km',
//                   safetyPct: 78,
//                   tags: const ['Busy Street', 'Lit'],
//                 ),
//                 const SizedBox(height: 12),
//                 _RouteCard(
//                   name: 'Via Back Road',
//                   time: '10 min',
//                   distance: '0.9 km',
//                   safetyPct: 55,
//                   tags: const ['Shortcut'],
//                 ),
//                 const SizedBox(height: 20),
//               ]),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _buildInputCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: kCardDecoration,
//       child: Column(children: [
//         _RouteInputRow(dotColor: kPink, hint: 'Current Location'),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//           child: Divider(color: kLightPurple, thickness: 1),
//         ),
//         _RouteInputRow(dotColor: kPurple, hint: 'Where are you going?'),
//       ]),
//     );
//   }

//   Widget _buildRoutePreview() {
//     return Container(
//       height: 180,
//       decoration: BoxDecoration(
//         gradient: kMapGradient,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Stack(children: [
//         CustomPaint(size: Size.infinite, painter: _DashedRoutePainter()),
//         const Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.near_me_rounded, color: kPurple, size: 32),
//             SizedBox(height: 8),
//             Text('Route preview',
//                 style: TextStyle(color: kSubtext, fontSize: 14, fontWeight: FontWeight.w500)),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// // ─── Route Input Row ──────────────────────────────────────────────────────────
// class _RouteInputRow extends StatelessWidget {
//   final Color dotColor;
//   final String hint;

//   const _RouteInputRow({required this.dotColor, required this.hint});

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Container(
//         width: 12,
//         height: 12,
//         decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
//       ),
//       const SizedBox(width: 14),
//       Expanded(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//           decoration: BoxDecoration(
//             color: kBg,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(hint, style: kCaption),
//         ),
//       ),
//     ]);
//   }
// }

// // ─── Safest Route Card (with badge) ──────────────────────────────────────────
// class _SafestRouteCard extends StatelessWidget {
//   final String name;
//   final String time;
//   final String distance;
//   final int safetyPct;
//   final List<String> tags;

//   const _SafestRouteCard({
//     required this.name,
//     required this.time,
//     required this.distance,
//     required this.safetyPct,
//     required this.tags,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(clipBehavior: Clip.none, children: [
//       Container(
//         padding: const EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: kPink.withOpacity(0.3), width: 1.5),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
//         ),
//         child: _RouteCardContent(
//           name: name,
//           time: time,
//           distance: distance,
//           safetyPct: safetyPct,
//           tags: tags,
//         ),
//       ),
//       Positioned(
//         top: -1,
//         right: 20,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//           decoration: const BoxDecoration(
//             gradient: kPinkPurpleGradient,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//           ),
//           child: const Row(mainAxisSize: MainAxisSize.min, children: [
//             Icon(Icons.star_rounded, color: Colors.white, size: 14),
//             SizedBox(width: 4),
//             Text('Safest',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
//           ]),
//         ),
//       ),
//     ]);
//   }
// }

// // ─── Regular Route Card ───────────────────────────────────────────────────────
// class _RouteCard extends StatelessWidget {
//   final String name;
//   final String time;
//   final String distance;
//   final int safetyPct;
//   final List<String> tags;

//   const _RouteCard({
//     required this.name,
//     required this.time,
//     required this.distance,
//     required this.safetyPct,
//     required this.tags,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: kCardDecoration,
//       child: _RouteCardContent(
//         name: name,
//         time: time,
//         distance: distance,
//         safetyPct: safetyPct,
//         tags: tags,
//       ),
//     );
//   }
// }

// // ─── Route Card Content ───────────────────────────────────────────────────────
// class _RouteCardContent extends StatelessWidget {
//   final String name;
//   final String time;
//   final String distance;
//   final int safetyPct;
//   final List<String> tags;

//   const _RouteCardContent({
//     required this.name,
//     required this.time,
//     required this.distance,
//     required this.safetyPct,
//     required this.tags,
//   });

//   Color get _safetyColor {
//     if (safetyPct >= 80) return const Color(0xFF27AE60);
//     if (safetyPct >= 60) return const Color(0xFFF39C12);
//     return const Color(0xFFE74C3C);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(children: [
//         const Icon(Icons.route_rounded, color: kText, size: 22),
//         const SizedBox(width: 10),
//         Text(name,
//             style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: kText)),
//         const Spacer(),
//         Text('$safetyPct%',
//             style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: _safetyColor)),
//       ]),
//       const SizedBox(height: 8),
//       Row(children: [
//         const Icon(Icons.access_time_rounded, size: 15, color: kSubtext),
//         const SizedBox(width: 5),
//         Text(time, style: kCaption),
//         const SizedBox(width: 14),
//         Text(distance, style: kCaption),
//       ]),
//       const SizedBox(height: 10),
//       Wrap(spacing: 8, children: tags.map((t) => PillTag(t)).toList()),
//     ]);
//   }
// }

// // ─── Dashed Route Painter ─────────────────────────────────────────────────────
// class _DashedRoutePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = kPink.withOpacity(0.4)
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final path = Path()
//       ..moveTo(size.width * 0.1, size.height * 0.7)
//       ..cubicTo(
//         size.width * 0.3, size.height * 0.3,
//         size.width * 0.6, size.height * 0.7,
//         size.width * 0.9, size.height * 0.3,
//       );

//     const dashLen = 8.0;
//     const gapLen = 6.0;

//     for (final metric in path.computeMetrics()) {
//       double d = 0;
//       while (d < metric.length) {
//         final end = (d + dashLen).clamp(0.0, metric.length);
//         canvas.drawPath(metric.extractPath(d, end), paint);
//         d += dashLen + gapLen;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter _) => false;
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../theme/app_theme.dart';
// import '../widgets/common_widgets.dart';

// class RoutesScreen extends StatefulWidget {
//   const RoutesScreen({super.key});

//   @override
//   State<RoutesScreen> createState() => _RoutesScreenState();
// }

// class _RoutesScreenState extends State<RoutesScreen> {

//   List<LatLng> routePoints = [];

//   final LatLng startLocation = LatLng(18.5204, 73.8567);
//   final LatLng endLocation = LatLng(18.5314, 73.8446);

//   @override
//   void initState() {
//     super.initState();
//     loadRoute();
//   }

//   Future loadRoute() async {

//     try {

//       final response = await http.post(
//         Uri.parse("http://127.0.0.1:5000/get-route"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "start_lat": startLocation.latitude,
//           "start_lng": startLocation.longitude,
//           "end_lat": endLocation.latitude,
//           "end_lng": endLocation.longitude
//         }),
//       );

//       var data = jsonDecode(response.body);

//       List coords = data["route"];

//       setState(() {
//         routePoints = coords
//             .map((c) => LatLng(c[1], c[0]))
//             .toList();
//       });

//     } catch (e) {
//       print("Route fetch error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBg,
//       body: SafeArea(
//         child: Column(children: [

//           const PageHeader(title: 'Safe Routes'),

//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   _buildInputCard(),

//                   const SizedBox(height: 16),

//                   _buildRoutePreview(),

//                   const SizedBox(height: 20),

//                   const Text('Suggested Routes', style: kTitle),

//                   const SizedBox(height: 12),

//                   const _SafestRouteCard(
//                     name: 'Safest Route',
//                     time: '12 min',
//                     distance: '1.2 km',
//                     safetyPct: 92,
//                     tags: ['Well-lit', 'CCTV'],
//                   ),

//                   const SizedBox(height: 12),

//                   const _RouteCard(
//                     name: 'Alternate Route',
//                     time: '15 min',
//                     distance: '1.5 km',
//                     safetyPct: 78,
//                     tags: ['Busy Street', 'Lit'],
//                   ),

//                   const SizedBox(height: 12),

//                   const _RouteCard(
//                     name: 'Shortest Route',
//                     time: '10 min',
//                     distance: '0.9 km',
//                     safetyPct: 55,
//                     tags: ['Shortcut'],
//                   ),

//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _buildInputCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: kCardDecoration,
//       child: Column(children: [

//         _RouteInputRow(dotColor: kPink, hint: 'Current Location'),

//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//           child: Divider(color: kLightPurple, thickness: 1),
//         ),

//         _RouteInputRow(dotColor: kPurple, hint: 'Where are you going?'),

//       ]),
//     );
//   }

//   Widget _buildRoutePreview() {
//     return Container(
//       height: 250,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: FlutterMap(
//           options: MapOptions(
//             initialCenter: startLocation,
//             initialZoom: 14,
//           ),
//           children: [

//             TileLayer(
//               urlTemplate:
//               "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//             ),

//             MarkerLayer(
//               markers: [

//                 Marker(
//                   point: startLocation,
//                   width: 40,
//                   height: 40,
//                   child: const Icon(Icons.my_location, color: Colors.blue),
//                 ),

//                 Marker(
//                   point: endLocation,
//                   width: 40,
//                   height: 40,
//                   child: const Icon(Icons.location_on, color: Colors.red),
//                 ),

//               ],
//             ),

//             PolylineLayer(
//               polylines: [

//                 Polyline(
//                   points: routePoints,
//                   strokeWidth: 5,
//                   color: Colors.pink,
//                 ),

//               ],
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }

// class _RouteInputRow extends StatelessWidget {
//   final Color dotColor;
//   final String hint;

//   const _RouteInputRow({required this.dotColor, required this.hint});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: dotColor,
//           ),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             decoration: BoxDecoration(
//               color: kBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(hint, style: kCaption),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _RouteCard extends StatelessWidget {
//   final String name;
//   final String time;
//   final String distance;
//   final int safetyPct;
//   final List<String> tags;

//   const _RouteCard({
//     required this.name,
//     required this.time,
//     required this.distance,
//     required this.safetyPct,
//     required this.tags,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: kCardDecoration,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.route_rounded, color: kText),
//               const SizedBox(width: 10),
//               Text(name, style: kTitle),
//               const Spacer(),
//               Text("$safetyPct%"),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text("$time • $distance"),
//         ],
//       ),
//     );
//   }
// }

// class _SafestRouteCard extends StatelessWidget {
//   final String name;
//   final String time;
//   final String distance;
//   final int safetyPct;
//   final List<String> tags;

//   const _SafestRouteCard({
//     required this.name,
//     required this.time,
//     required this.distance,
//     required this.safetyPct,
//     required this.tags,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _RouteCard(
//           name: name,
//           time: time,
//           distance: distance,
//           safetyPct: safetyPct,
//           tags: tags,
//         ),
//         Positioned(
//           right: 10,
//           top: 0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: const BoxDecoration(
//               color: Colors.pink,
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             child: const Text(
//               "Safest",
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../theme/app_theme.dart';
// import '../widgets/common_widgets.dart';

// class RoutesScreen extends StatefulWidget {
//   const RoutesScreen({super.key});

//   @override
//   State<RoutesScreen> createState() => _RoutesScreenState();
// }

// class _RoutesScreenState extends State<RoutesScreen> {

//   LatLng? currentLocation;

//   final TextEditingController destinationController = TextEditingController();
//   List<LatLng> routePoints = [];

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//   }

//   Future getCurrentLocation() async {

//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//     if (!serviceEnabled) {
//       return;
//     }

//     LocationPermission permission =
//         await Geolocator.requestPermission();

//     Position position =
//         await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       currentLocation =
//           LatLng(position.latitude, position.longitude);
//     });

//     loadRoute();
//   }

//   Future loadRoute() async {

//     if (currentLocation == null) return;

//     try {

//       final response = await http.post(
//         Uri.parse("http://127.0.0.1:5000/api/get-route"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "start_lat": currentLocation!.latitude,
//           "start_lng": currentLocation!.longitude,
//           "end_lat": destination.latitude,
//           "end_lng": destination.longitude
//         }),
//       );

//       var data = jsonDecode(response.body);

//       List coords = data["route"];

//       setState(() {
//         routePoints =
//             coords.map((c) => LatLng(c[1], c[0])).toList();
//       });

//     } catch (e) {
//       print("Route error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: kBg,

//       body: SafeArea(
//         child: Column(
//           children: [

//             const PageHeader(title: 'Safe Routes'),

//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [

//                     _buildRoutePreview(),

//                     const SizedBox(height: 16),

//                     ElevatedButton.icon(
//                       onPressed: loadRoute,
//                       icon: const Icon(Icons.navigation),
//                       label: const Text("Get Directions"),
//                     ),

//                   ],
//                 ),
//               ),
//             ),

//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoutePreview() {

//     if (currentLocation == null) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return Container(
//       height: 320,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),

//         child: FlutterMap(

//           options: MapOptions(
//             initialCenter: currentLocation!,
//             initialZoom: 15,
//           ),

//           children: [

//             TileLayer(
//               urlTemplate:
//                   "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//             ),

//             MarkerLayer(
//               markers: [

//                 Marker(
//                   point: currentLocation!,
//                   width: 40,
//                   height: 40,
//                   child: const Icon(
//                     Icons.my_location,
//                     color: Colors.blue,
//                     size: 35,
//                   ),
//                 ),

//                 Marker(
//                   point: destination,
//                   width: 40,
//                   height: 40,
//                   child: const Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                     size: 35,
//                   ),
//                 ),

//               ],
//             ),

//             PolylineLayer(
//               polylines: [
//                 Polyline(
//                   points: routePoints,
//                   strokeWidth: 5,
//                   color: Colors.pink,
//                 )
//               ],
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  LatLng? currentLocation;
  LatLng? sourceLocation;
  LatLng? destination;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  List<LatLng> routePoints = [];
  List<dynamic> routes = [];
  int selectedRouteIndex = 0;

  bool loadingRoute = false;
  bool loadingCrime = false;
  Map<String, dynamic>? crimeSummary;

  // Live Location Safety Score variables
  double? currentSafetyScore;
  String? currentSafetyRating;
  String? currentSuburb;
  Timer? _liveSafetyTimer;

  @override
  void initState() {
    super.initState();
    sourceController.text = "Current Location";
    getCurrentLocation();
  }

  @override
  void dispose() {
    _liveSafetyTimer?.cancel();
    sourceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // Get Live Location
  // ─────────────────────────────────────────
  Future getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      if (sourceController.text == "Current Location" ||
          sourceController.text.isEmpty) {
        sourceLocation = currentLocation;
        sourceController.text = "Current Location";
      }
    });

    startLiveSafetyTracking();
  }

  // ─────────────────────────────────────────
  // Live Safety tracking scheduler
  // ─────────────────────────────────────────
  void startLiveSafetyTracking() {
    _liveSafetyTimer?.cancel();

    // Initial immediate fetch
    fetchLiveSafetyScore();

    // Periodically fetch safety score every 10 seconds
    _liveSafetyTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchLiveSafetyScore();
    });
  }

  // ─────────────────────────────────────────
  // Fetch Safety Score at current user location
  // ─────────────────────────────────────────
  Future fetchLiveSafetyScore() async {
    if (currentLocation == null) return;

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/api/current-safety"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "lat": currentLocation!.latitude,
          "lng": currentLocation!.longitude,
          "current_time": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          currentSafetyScore = (data["safety_score"] as num).toDouble();
          currentSafetyRating = data["safety_rating"];
          currentSuburb = data["suburb"];
        });
      }
    } catch (e) {
      print("Live safety track error: $e");
    }
  }

  // ─────────────────────────────────────────
  // Get source coordinates from backend
  // ─────────────────────────────────────────
  Future getSourceCoordinates() async {
    if (sourceController.text.isEmpty) {
      sourceLocation = null;
      return;
    }

    if (sourceController.text.trim() == "Current Location") {
      sourceLocation = currentLocation;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/api/destination"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"address": sourceController.text}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          sourceLocation = LatLng(data["lat"], data["lng"]);
        });
      } else {
        setState(() {
          sourceLocation = null;
        });
      }
    } catch (e) {
      print("Source geocode error: $e");
      setState(() {
        sourceLocation = null;
      });
    }
  }

  // ─────────────────────────────────────────
  // Get destination coordinates from backend
  // ─────────────────────────────────────────
  Future getDestinationCoordinates() async {
    if (destinationController.text.isEmpty) {
      destination = null;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/api/destination"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"address": destinationController.text}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          destination = LatLng(data["lat"], data["lng"]);
        });
      } else {
        setState(() {
          destination = null;
        });
      }
    } catch (e) {
      print("Destination geocode error: $e");
      setState(() {
        destination = null;
      });
    }
  }

  // ─────────────────────────────────────────
  // Get Crime Summary from backend
  // ─────────────────────────────────────────
  Future loadCrimeSummary() async {
    if (sourceLocation == null || destination == null) return;

    setState(() {
      loadingCrime = true;
      crimeSummary = null;
    });

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/api/crime-summary"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "start_lat": sourceLocation!.latitude,
          "start_lng": sourceLocation!.longitude,
          "end_lat": destination!.latitude,
          "end_lng": destination!.longitude,
          "current_time": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          crimeSummary = data;
          loadingCrime = false;
        });
      } else {
        setState(() {
          loadingCrime = false;
        });
      }
    } catch (e) {
      print("Crime summary error: $e");
      setState(() {
        loadingCrime = false;
      });
    }
  }

  // ─────────────────────────────────────────
  // Get Route from backend
  // ─────────────────────────────────────────
  Future loadRoute() async {
    if (currentLocation == null) return;

    setState(() {
      loadingRoute = true;
      routes = [];
      selectedRouteIndex = 0;
    });

    await getSourceCoordinates();
    await getDestinationCoordinates();

    if (sourceLocation == null || destination == null) {
      setState(() {
        loadingRoute = false;
      });
      // Show elegant SnackBar error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Failed to resolve route coordinates. Please verify addresses.",
            ),
            backgroundColor: Color(0xFFE74C3C),
          ),
        );
      }
      return;
    }

    // Load crime reports in parallel as backup
    loadCrimeSummary();

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/api/get-route"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "start_lat": sourceLocation!.latitude,
          "start_lng": sourceLocation!.longitude,
          "end_lat": destination!.latitude,
          "end_lng": destination!.longitude,
          "current_time": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          routes = data["routes"] ?? [];
          if (data["crime_summary"] != null) {
            crimeSummary = data["crime_summary"];
          }
          if (routes.isNotEmpty) {
            selectedRouteIndex = 0;
            List coords = routes[0]["route"];
            routePoints = coords.map((c) => LatLng(c[1], c[0])).toList();
          } else {
            routePoints = [];
          }
          loadingRoute = false;
        });
      } else {
        print("Route server returned status: ${response.statusCode}");
        setState(() {
          loadingRoute = false;
        });
      }
    } catch (e) {
      print("Route error: $e");
      setState(() {
        loadingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,

      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Safe Routes'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInputCard(),

                    const SizedBox(height: 16),

                    _buildMapPreview(),

                    const SizedBox(height: 16),

                    if (routes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Suggested Routes',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: kText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRouteSwitcherList(),
                      const SizedBox(height: 18),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: loadingRoute ? null : loadRoute,
                        icon: const Icon(Icons.navigation),
                        label: loadingRoute
                            ? const Text("Loading route...")
                            : const Text("Get Directions"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildCrimeSummaryCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Premium Safety & Crime Analytics Card
  // ─────────────────────────────────────────
  Widget _buildCrimeSummaryCard() {
    if (loadingCrime) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: kCardDecoration,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(kPink),
                ),
              ),
              SizedBox(height: 14),
              Text(
                "Analyzing route crime intelligence...",
                style: TextStyle(
                  color: kSubtext,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (crimeSummary == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: kCardDecoration,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: kLightPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: kPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SafeHer Safety Intelligence",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kText,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Enter your destination to fetch real-time route analytics and crime reports.",
                    style: TextStyle(fontSize: 12, color: kSubtext),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final summary = crimeSummary!;
    final overallRating = summary["overall_safety_rating"] ?? "High Safety";
    final timePeriod = summary["current_time_period"] ?? "Unknown";
    final tip = summary["safety_tip"] ?? "";
    final startArea = summary["start_area"] ?? {};
    final endArea = summary["end_area"] ?? {};
    final breakdown = summary["crime_breakdown"] as Map<String, dynamic>? ?? {};

    Color ratingColor;
    IconData ratingIcon;

    if (overallRating == "Caution Advised") {
      ratingColor = const Color(0xFFE74C3C);
      ratingIcon = Icons.warning_rounded;
    } else if (overallRating == "Moderate Safety") {
      ratingColor = const Color(0xFFF39C12);
      ratingIcon = Icons.info_outline_rounded;
    } else {
      ratingColor = const Color(0xFF27AE60);
      ratingIcon = Icons.verified_user_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: kCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: kPurple, size: 22),
              const SizedBox(width: 8),
              const Text(
                "Crime & Safety Report",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: kText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ratingColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(ratingIcon, color: ratingColor, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      overallRating,
                      style: TextStyle(
                        color: ratingColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Travel Hour Period: $timePeriod",
            style: const TextStyle(
              color: kSubtext,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF2EDF8)),
          const SizedBox(height: 14),
          // Suburb stats side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "START SUBURB",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: kSubtext,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      startArea["name"] ?? "Start Location",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${startArea['distance_km']} km away",
                      style: const TextStyle(fontSize: 11, color: kSubtext),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total Crimes: ${startArea['total_crimes']}",
                      style: const TextStyle(fontSize: 12, color: kText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$timePeriod: ${startArea['period_crimes']} cases",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPurple,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 80, width: 1, color: const Color(0xFFF2EDF8)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "DESTINATION SUBURB",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: kSubtext,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      endArea["name"] ?? "Destination",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${endArea['distance_km']} km away",
                      style: const TextStyle(fontSize: 11, color: kSubtext),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total Crimes: ${endArea['total_crimes']}",
                      style: const TextStyle(fontSize: 12, color: kText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$timePeriod: ${endArea['period_crimes']} cases",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Crime Categories Pills
          if (breakdown.isNotEmpty) ...[
            const Text(
              "TOP ROUTE INCIDENT TYPES",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: kSubtext,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: breakdown.entries.map((e) {
                return PillTag(
                  "${e.key}: ${e.value}",
                  bg: kLightPink,
                  fg: kPink,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          // Tip alert
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: overallRating == "Caution Advised"
                  ? const Color(0xFFFFF5F5)
                  : const Color(0xFFF6FDF9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: overallRating == "Caution Advised"
                    ? const Color(0xFFFFD8D8)
                    : const Color(0xFFE1F7EC),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  overallRating == "Caution Advised"
                      ? Icons.warning_amber_rounded
                      : Icons.lightbulb_outline_rounded,
                  color: overallRating == "Caution Advised"
                      ? const Color(0xFFE74C3C)
                      : const Color(0xFF27AE60),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: TextStyle(
                      fontSize: 12,
                      color: overallRating == "Caution Advised"
                          ? const Color(0xFFC0392B)
                          : const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Destination input card
  // ─────────────────────────────────────────
  // ─────────────────────────────────────────
  // Combined Premium Source & Destination Input Card
  // ─────────────────────────────────────────
  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: sourceController,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Enter source address",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.my_location_rounded,
                  color: sourceController.text == "Current Location"
                      ? Colors.blue
                      : kSubtext,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    sourceController.text = "Current Location";
                    sourceLocation = currentLocation;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Divider(color: kLightPurple.withOpacity(0.5), thickness: 1),
          ),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPink,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: destinationController,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Enter destination",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Compile Map Markers Dynamically
  // ─────────────────────────────────────────
  List<Marker> _buildMapMarkers() {
    List<Marker> list = [];

    // 1. Live location tracking marker
    if (currentLocation != null) {
      list.add(
        Marker(
          point: currentLocation!,
          width: 40,
          height: 40,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 34),
        ),
      );
    }

    // 2. Start route location marker (green/blue circle if custom start)
    if (sourceLocation != null && sourceLocation != currentLocation) {
      list.add(
        Marker(
          point: sourceLocation!,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.trip_origin_rounded,
            color: Colors.blue,
            size: 26,
          ),
        ),
      );
    }

    // 3. Destination location marker
    if (destination != null) {
      list.add(
        Marker(
          point: destination!,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_on, color: Colors.red, size: 34),
        ),
      );
    }

    // 4. Police stations along the selected route
    if (routes.isNotEmpty &&
        selectedRouteIndex >= 0 &&
        selectedRouteIndex < routes.length) {
      final route = routes[selectedRouteIndex];
      final List<dynamic> stations = route["police_stations"] ?? [];
      for (var station in stations) {
        final double? lat = (station["lat"] as num?)?.toDouble();
        final double? lng = (station["lng"] as num?)?.toDouble();
        final String name = station["name"] ?? "Police Station";
        if (lat != null && lng != null) {
          list.add(
            Marker(
              point: LatLng(lat, lng),
              width: 34,
              height: 34,
              child: Tooltip(
                message: name,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.indigo, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.35),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_police_rounded,
                    color: Colors.indigo,
                    size: 18,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return list;
  }

  // ─────────────────────────────────────────
  // Map Preview
  // ─────────────────────────────────────────
  Widget _buildMapPreview() {
    if (currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 320,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: sourceLocation ?? currentLocation!,
                initialZoom: 14,
              ),

              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),

                MarkerLayer(markers: _buildMapMarkers()),

                PolylineLayer(polylines: _buildPolylines()),
              ],
            ),

            // Glowing Live Safety Widget Floating on the Top-Right of Map
            Positioned(top: 12, right: 12, child: _buildLiveSafetyBadge()),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Glowing Live Safety Score Badge
  // ─────────────────────────────────────────
  Widget _buildLiveSafetyBadge() {
    if (currentLocation == null) return const SizedBox.shrink();

    final score = currentSafetyScore ?? 85.0;
    final suburb = currentSuburb ?? "Determining Suburb...";

    Color ratingColor;
    if (score >= 80.0) {
      ratingColor = const Color(0xFF27AE60);
    } else if (score >= 60.0) {
      ratingColor = const Color(0xFFF39C12);
    } else {
      ratingColor = const Color(0xFFE74C3C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ratingColor.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ratingColor.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPulseDot(ratingColor),
              const SizedBox(width: 6),
              Text(
                "LIVE SCORE",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey[800],
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "${score.round()}%",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: ratingColor,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            suburb,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Tween-animated Pulsing live green/orange/red dot
  // ─────────────────────────────────────────
  Widget _buildPulseDot(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.35, end: 1.0),
      duration: const Duration(milliseconds: 1100),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.7),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  // Route color coordinator (Blue for Safest, distinct colors for alternates)
  // ─────────────────────────────────────────
  Color _getRouteColor(int index, bool isSelected, bool isSafest) {
    if (isSafest) {
      return isSelected ? Colors.blue : Colors.blue.withOpacity(0.35);
    }

    Color baseColor;
    switch (index) {
      case 1:
        baseColor = const Color(0xFFF39C12); // Radiant Coral-Orange
        break;
      case 2:
        baseColor = const Color(0xFF27AE60); // Emerald Green
        break;
      case 3:
        baseColor = const Color(0xFF8E44AD); // Deep Purple
        break;
      default:
        baseColor = const Color(0xFFE91E63); // Radiant Pink/Rose
    }

    return isSelected ? baseColor : baseColor.withOpacity(0.35);
  }

  // ─────────────────────────────────────────
  // Build Route Polyline Layers
  // ─────────────────────────────────────────
  List<Polyline> _buildPolylines() {
    List<Polyline> list = [];
    if (routes.isEmpty) {
      if (routePoints.isNotEmpty) {
        list.add(Polyline(points: routePoints, strokeWidth: 5.0, color: kPink));
      }
      return list;
    }

    // Render unselected routes first, so selected route is drawn on top
    for (int i = routes.length - 1; i >= 0; i--) {
      if (i == selectedRouteIndex) continue;

      final route = routes[i];
      List coords = route["route"] ?? [];
      List<LatLng> points = coords.map((c) => LatLng(c[1], c[0])).toList();
      final isSafest = i == 0;

      list.add(
        Polyline(
          points: points,
          strokeWidth: 4.5,
          color: _getRouteColor(i, false, isSafest),
        ),
      );
    }

    // Render active selected route on top
    if (selectedRouteIndex >= 0 && selectedRouteIndex < routes.length) {
      final route = routes[selectedRouteIndex];
      List coords = route["route"] ?? [];
      List<LatLng> points = coords.map((c) => LatLng(c[1], c[0])).toList();
      final isSafest = selectedRouteIndex == 0;

      list.add(
        Polyline(
          points: points,
          strokeWidth: 6.5,
          color: _getRouteColor(selectedRouteIndex, true, isSafest),
        ),
      );
    }

    return list;
  }

  // ─────────────────────────────────────────
  // Build Interactive Suggested Routes List
  // ─────────────────────────────────────────
  Widget _buildRouteSwitcherList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: routes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final route = routes[index];
        final isSelected = index == selectedRouteIndex;
        final isSafest = index == 0;

        final double safetyScore = (route["safety_score"] as num).toDouble();
        final double distanceMeters = (route["distance"] as num).toDouble();
        final double durationSeconds = (route["duration"] as num).toDouble();

        final String durationStr = "${(durationSeconds / 60).round()} min";
        final String distanceStr =
            "${(distanceMeters / 1000).toStringAsFixed(1)} km";

        final int policeStations = route["police_stations_count"] ?? 0;
        final int crimes = route["period_crimes"] ?? 0;

        Color scoreColor;
        if (safetyScore >= 80.0) {
          scoreColor = const Color(0xFF27AE60);
        } else if (safetyScore >= 60.0) {
          scoreColor = const Color(0xFFF39C12);
        } else {
          scoreColor = const Color(0xFFE74C3C);
        }

        Color routeColor = _getRouteColor(index, true, isSafest);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedRouteIndex = index;
              List coords = route["route"];
              routePoints = coords.map((c) => LatLng(c[1], c[0])).toList();
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? routeColor
                        : Colors.grey.withOpacity(0.15),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? routeColor.withOpacity(0.15)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.route_rounded, color: routeColor, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          isSafest ? "Safest Route" : "Alternate Route $index",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: kText,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${safetyScore.round()}% Safety",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: scoreColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 15,
                          color: kSubtext,
                        ),
                        const SizedBox(width: 5),
                        Text(durationStr, style: kCaption),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.map_outlined,
                          size: 15,
                          color: kSubtext,
                        ),
                        const SizedBox(width: 5),
                        Text(distanceStr, style: kCaption),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        PillTag(
                          "$policeStations Police Stations",
                          bg: Colors.blue.withOpacity(0.08),
                          fg: Colors.blue[700],
                        ),
                        PillTag(
                          "$crimes crimes recently",
                          bg: crimes > 20
                              ? const Color(0xFFFFF0F0)
                              : const Color(0xFFEBFDF3),
                          fg: crimes > 20
                              ? const Color(0xFFC0392B)
                              : const Color(0xFF27AE60),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSafest)
                Positioned(
                  top: -1,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [routeColor, routeColor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'RECOMMENDED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
