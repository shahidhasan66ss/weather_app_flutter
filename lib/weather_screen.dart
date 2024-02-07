
import 'dart:convert';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/theme_provider.dart';
import 'hourly_forcast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future <Map<String,dynamic>> weather;

  Future <Map<String,dynamic>> getCurrentWeather() async{
    try{
      String cityName = 'Dhaka';
      final res = await http.get(
          Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherApiKey'),

      );
      final data = jsonDecode(res.body);
      
        if(data['cod'] != '200'){
          throw data['message'];
        }
        return data;
    }
    catch(e){
      throw e.toString();
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  double kelvinToCelsius(double kelvinTemperature) {
    return kelvinTemperature - 273.15;
  }
  String formatTemperature(double temperature) {
    return temperature.toStringAsFixed(2);
  }



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App", style: TextStyle(fontWeight: FontWeight.bold),),centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // Toggle between light and dark theme modes
                final ThemeMode nextThemeMode =
                themeProvider.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

                themeProvider.setThemeMode(nextThemeMode);
              });

            },
            icon: themeProvider.themeMode == ThemeMode.light
                ? Icon(Icons.light_mode)
                : Icon(Icons.dark_mode),
          ),
          IconButton(onPressed: (){
            setState(() {
              weather = getCurrentWeather();
            });
          }, icon: Icon(Icons.refresh))
        ],
      ),

      body:FutureBuilder(
        future: weather,
        builder:(context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTempKelvin = currentWeatherData['main']['temp'];
          final currentTempCelsius = kelvinToCelsius(currentTempKelvin);
          final formattedCurrentTemp = formatTemperature(currentTempCelsius);
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 10, sigmaY: 10
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$formattedCurrentTemp °C',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold
                                ),

                              ),
                              SizedBox(height: 16,),
                              Icon(
                                currentSky=='Clouds' || currentSky=='Rain' ?
                                    Icons.cloud : Icons.sunny,size: 64,),
                              SizedBox(height: 16,),
                              Text(
                                '$currentSky',
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                //   forcasr cards
                Text("Weather Forscast",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),

                SizedBox(height: 20,),


                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        final hourlyForecast = data['list'][index + 1];
                        final hourlyTempKelvin = hourlyForecast['main']['temp'];
                        final hourlyTempCelsius = kelvinToCelsius(hourlyTempKelvin);
                        final formattedHourlyTemp = formatTemperature(hourlyTempCelsius);
                        final hourlySky = data['list'][index + 1]['weather'][0]['main'].toString();
                        final time = DateTime.parse(hourlyForecast['dt_txt']);

                        return HourlyForcastCard(
                          time: DateFormat.j().format(time),
                          temperatur: formattedHourlyTemp,
                          icon: hourlySky=='Clouds'|| hourlySky=='Rain'
                          ? Icons.cloud : Icons.sunny,
                        );
                      },
                ),

                ),

                SizedBox(height: 20,),
                Text("Additional Information",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                SizedBox(height: 16,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(icon: Icons.water_drop, label: 'Humidity', value:currentHumidity.toString()),
                    AdditionalInfo(icon: Icons.air, label: 'Wind Speed', value:currentWindSpeed.toString()),
                    AdditionalInfo(icon: Icons.beach_access, label: 'Pressure', value: currentPressure.toString()),

                  ],
                )

              ],
            ),
          );
        },
      ),

    );
  }
}










