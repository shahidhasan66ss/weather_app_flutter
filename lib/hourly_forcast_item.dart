import 'package:flutter/material.dart';

class HourlyForcastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperatur;

  const HourlyForcastCard({
    super.key,
    required this.time,
    required this.icon,
    required this.temperatur,
});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8,),
            Icon(icon,size: 32,),
            SizedBox(height: 8,),
            Text(
              temperatur,
            ),
          ],
        ),
      ),
    );
  }
}