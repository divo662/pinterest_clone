import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest_clone/components/global_constants.dart';
import 'package:pinterest_clone/screens/bottom_nav_bar.dart';
import '../api/pexel_api_class.dart';
import '../model/pexel_model.dart';
import '../widget/loading_Widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 1;
  bool isStarted = false;
  final PexelsApi pexelsApi =
  PexelsApi(apiKey: 'MsB5RufxehOuViswILug2dAoqBtlXvyrRdfA0n1GnLL2MCIMbA2eD8Sk');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 90.h,),
          FutureBuilder<List<Photo>>(
            future: pexelsApi.getCuratedPhotos(page: 1, perPage: 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  YourLoadingWidget(
                  child: Container(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final List<Photo> curatedPhotos = snapshot.data!;
                final middleIndex = curatedPhotos.length ~/ 2;
                return CarouselSlider(
                  options: CarouselOptions(
                    height: 380.h,
                    initialPage: middleIndex,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    enableInfiniteScroll: true,
                  ),
                  items: curatedPhotos.map((photo) {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(photo.src['large']),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return  YourLoadingWidget(
                  child: Center(
                    child: Text(
                      "Error Loading",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(height: 40.h,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find New Collections",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 31.sp,
                      wordSpacing: 2.5,
                      letterSpacing: 1.5
                  ),
                ),
                Text(
                  "Unveil a World of Artistry and Creativity Through"
                      " Captivating Collections, Where Every Image"
                      " Tells a Story and Every Moment Sparks Imagination.",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                  ),
                ),
                SizedBox(height: heightValue15,),
                FlutterSwitch(
                  width: 360.w,
                  height: 70.h,
                  valueFontSize: 16.0,
                  toggleSize: 55.0,
                  value: isStarted,
                  borderRadius: 30.0,
                  padding: 8.0,
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey.shade800,
                  activeText: 'Start',
                  inactiveIcon: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white,),
                  activeTextColor: Colors.black,
                  duration: const Duration(seconds: 4),
                  onToggle: (value) {
                    setState(() {
                      isStarted = value;
                      if (isStarted) {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BottomNavBarScreen()),
                        );
                      }
                    });
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

}



