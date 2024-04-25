import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    super.initState();
    getCurrentLocation();
  }

  num latitude1 = 0;
  num longitude1 = 0;
  num distance = 0;

  Future<Position> determinatePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinatePosition();
    print(position.latitude);
    print(position.longitude);
    print("Hora de:" + position.timestamp.timeZoneName);
    latitude1 = position.latitude;
    longitude1 = position.longitude;

    setState(() {
      
    });
  }

  num calculateDistance(lat1, long1, lat2, long2){
    double newlat1 = degreesToRadians(lat1);
    double newlat2 = degreesToRadians(lat2);
    double newlong1 = degreesToRadians(long1);
    double newlong2 = degreesToRadians(long2);

    num latTheta = newlat2 - newlat1;
    num longTheta = newlong2 - newlong1;
    num radius = 6371;

    double a = pow(sin(latTheta/2), 2) + cos(newlat1) * cos(newlat2) * pow(sin(longTheta/2), 2);
    distance = 2 * radius * atan2(sqrt(a), sqrt(1 - a));

    print(distance);

    setState(() {
      
    });

    return distance;
  }

  double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geolocator"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if(latitude1 == 0 && longitude1 == 0)
            ...[
              const Text('Latitud actual: Sin calcular'),
              const Text('Longitud actual: Sin calcular'),
            ] else
            ...[
              Text('Latitud actual: $latitude1'),
              Text('Longitud actual: $longitude1'),
            ],

            Expanded(
              child: ListView(
              children: <Widget> [
                ListTile(
                  title: const Text("Universidad de la Costa CUC"),
                  trailing: ElevatedButton(
                    onPressed:(){
                      calculateDistance(latitude1, longitude1, 10.995243675751345, -74.78978125954394);
                    } , 
                    child: const Text("Calcular Distancia"),
                  ),
                ),
                ListTile(
                  title: const Text("Centro Comercial Parque Alegra, "),
                  trailing: ElevatedButton(
                    onPressed:(){
                      calculateDistance(latitude1, longitude1, 10.943988528683542, -74.78362190291645);
                    } , 
                    child: const Text("Calcular Distancia"),
                  ),
                ),
                ListTile(
                  title: const Text("Camino Universitario Distrital Adelita de Char"),
                  trailing: ElevatedButton(
                    onPressed:(){
                      calculateDistance(latitude1, longitude1, 10.965362381292108, -74.7979909912768);
                    } , 
                    child: const Text("Calcular Distancia"),
                  ),
                ),
                ListTile(
                  title: const Text("Monserrate"),
                  trailing: ElevatedButton(
                    onPressed:(){
                      calculateDistance(latitude1, longitude1, 4.606027098563591, -74.05551162614147);
                    } , 
                    child: const Text("Calcular Distancia"),
                  ),
                ),
                ListTile(
                  title: const Text("Coliseo Romano"),
                  trailing: ElevatedButton(
                    onPressed:(){
                      calculateDistance(latitude1, longitude1, 41.890441788622, 12.492273811603047);
                    } , 
                    child: const Text("Calcular Distancia"),
                  ),
                ),
              ],
            ),
            ),
            if(distance == 0)
            ...[
              const Expanded(
                child:
                Text('Selecciones alguno de los sitios de la lista para calcular su distancia', 
                textAlign: TextAlign.center,),
              )
            ] else 
            ...[
              Expanded(
              child:
              Text('La distancia total entre tu posicion actual y la seleccionada es: ${distance.toStringAsFixed(3)}Km', 
              textAlign: TextAlign.center,),
            )
            ]
            
            
          ],
        ),
      ),
    );
  }
}

