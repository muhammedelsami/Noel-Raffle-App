import 'package:flutter/material.dart';
import 'package:noel_raffle/ui/about/about_screen.dart';
import 'package:noel_raffle/ui/giftraffle/gift_raffle_screen.dart';
import 'package:noel_raffle/ui/statistics/statistics_screen.dart';
import 'package:noel_raffle/ui/newyearscreen/newyear_screen.dart';
import 'package:url_launcher/url_launcher.dart'; // Eklemeyi unutmayın!

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 15,
              child: Image.asset(
                'assets/images/logo3.png',
                width: 108,
                height: 90,
              ),
            ),
            Positioned(
              right: 0,
              top: 15,
              child: Transform.scale(
                scale:
                    0.7, // Küçültme faktörü, 1 tam boyut demektir, 0.5 yarı boyut demektir
                child: GestureDetector(
                  onTap: () {
                    openDialog(context);
                  },
                  child: Image.asset(
                    'assets/images/Vector.png',
                    width: 50,
                    height: 90,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/gift-raffle.png',
                    width: 190,
                    height: 190,
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Hediye Çekilişi',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "DancingScript",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    'Çekiliş türü seçiniz',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "DancingScript",
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewYearScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEE1919),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          Size(270, 60), // Butonun minimum boyutunu belirler
                    ),
                    child: const Text(
                      'Yılbaşı Çekilişi',
                      style: TextStyle(
                          fontFamily: "DancingScript",
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GiftRaffleScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEE1919),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          Size(270, 60), // Butonun minimum boyutunu belirler
                    ),
                    child: const Text(
                      'Hediye Çekilişi',
                      style: TextStyle(
                          fontFamily: "DancingScript",
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Noel Raffle',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "DancingScript",
                color: Colors.red,
                fontSize: 35),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StatisticsScreen()),
                    );
                  },
                  child: Text('İstatistiklerimiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                  child: Text('Hakkımızda'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    const url = 'https://play.google.com/store/apps/details?id=com.muhammed.noel_raffle';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text('Bizi Değerlendir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    const url = 'https://www.noelraffle.com/tr';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text('Web Sitemiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    const url = 'https://github.com/edabarutcu/Noel-Raffle-App';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text('Katkıda Bulun'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kapat',
                    style: TextStyle(
                        fontFamily: "DancingScript",
                        color: Colors.red,
                        fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
