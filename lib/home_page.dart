import 'package:flutter/material.dart';
import 'package:weather_checker/services/location.dart';
import 'package:weather_checker/services/networking.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Location location = Location();
  final APIService apiService = APIService();
  bool loading = false;
  Map? weatherData;

  checkTemperature() async {
    setState(() {
      loading = true;
    });
    final longLat = await location.getCurrentLocation(context);
    final data = await apiService.getData(
      context: context,
      long: longLat["longitude"],
      lat: longLat["latitude"],
    );
    print(data);
    setState(() {
      weatherData = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: weatherData == null
          ? Colors.indigo[500]
          : weatherData!["main"]["temp"] > 30.0
              ? Colors.orange
              : Colors.indigo[600],
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: Colors.white.withOpacity(0.7)),
                  const SizedBox(height: 10),
                  const Text(
                    "Fetching...",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  weatherData == null
                      ? "Enable device location\nand proceed to check \n"
                          "the temperature"
                      : "It's ${weatherData!["main"]["temp"]}°C.\n"
                          "${weatherData!["main"]["temp"] > 30.0 ? "The weather's hot" : "The weather's cool"}"
                          "\n in ${weatherData!["name"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await checkTemperature();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: weatherData != null
                            ? weatherData!["main"]["temp"] > 30.0
                                ? Colors.orange
                                : Colors.indigo[600]
                            : Colors.indigo[600],
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Text(
                        "Check",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
