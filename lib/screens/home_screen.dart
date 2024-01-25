import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pinterest_clone/screens/images_details_screen.dart';
import 'package:pinterest_clone/widget/api_call_waiting_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../api/pexel_api_class.dart';
import '../model/pexel_model.dart';

import '../themes/container_random_colors.dart';
import '../widget/loading_Widget.dart';
import 'onboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 1;
  ScrollController scrollController = ScrollController();
  bool isStarted = false;
  List<Photo> curatedPhotos = [];
  bool isRefreshing = false;

  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PexelsApi pexelsApi = PexelsApi(
      apiKey: 'MsB5RufxehOuViswILug2dAoqBtlXvyrRdfA0n1GnLL2MCIMbA2eD8Sk');

  final List<String> quotes = [
    "Exploring moments, capturing dreams where every frame tells a story of "
        "timeless beauty.",
    "Seeking moments in pixels, where every frame tells a story, and each "
        "image is a masterpiece waiting to be discovered.",
    "Discover moments, capture stories. Elevate your world with curated "
        "creativity."
  ];

  void handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      List<Photo> newCuratedPhotos =
          await pexelsApi.getCuratedPhotos(page: 1, perPage: 15);

      setState(() {
        curatedPhotos = newCuratedPhotos;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error refreshing curated photos: $error');
      }
    }

    setState(() {
      isRefreshing = false;
    });
  }

  // void shareImage(String imageUrl, String photographer) {
  //   Share.share(
  //     'Check out this photo by $photographer: $imageUrl',
  //     subject: 'Photo Sharing',
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // Connectivity().checkConnectivity().then((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     showNoInternetSnackbar();
    //   }
    // });
    //
    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     showNoInternetSnackbar();
    //   }
    // });
  }

  // void showNoInternetSnackbar() {
  //   final snackBar = SnackBar(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     padding: const EdgeInsets.only(bottom: 750),
  //     dismissDirection: DismissDirection.endToStart,
  //     content: Container(
  //         width: 190.w,
  //         height: 56.h,
  //         decoration: BoxDecoration(
  //             shape: BoxShape.rectangle,
  //             borderRadius: BorderRadius.circular(45),
  //             color: Colors.red),
  //         child: Center(
  //           child: Text(
  //             "Hmm... you're not connected to the \n internet",
  //             style: GoogleFonts.poppins(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 17.sp),
  //             textAlign: TextAlign.center,
  //           ),
  //         )),
  //     duration: const Duration(seconds: 2),
  //   );
  //
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    // Connectivity().checkConnectivity().then((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     showNoInternetSnackbar();
    //   }
    // });

    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        handleRefresh;
      },
      showChildOpacityTransition: true,
      color: Colors.grey.shade900,
      springAnimationDurationInMilliseconds: 800,
      backgroundColor: Colors.grey.shade600,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool isScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 260.h,
                pinned: false,
                flexibleSpace: Stack(children: [
                  FutureBuilder<List<Photo>>(
                    future: pexelsApi.getCuratedPhotos(page: 1, perPage: 10),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 380.h,
                              initialPage: 1,
                              enlargeCenterPage: true,
                              viewportFraction: 1,
                              enlargeStrategy: CenterPageEnlargeStrategy.scale,
                              enableInfiniteScroll: true,
                            ),
                            items: List.generate(3, (index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                ),
                              );
                            }),
                          ),
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
                            autoPlay: true,
                            viewportFraction: 1,
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            enableInfiniteScroll: true,
                          ),
                          items: curatedPhotos.map((photo) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(photo.src['large']),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return YourLoadingWidget(
                          child: Center(
                            child: Text(
                              "Error Loading",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Center(
                      child: AnimatedTextKit(
                    animatedTexts: quotes.map((quote) {
                      return TypewriterAnimatedText(
                        quote,
                        textStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        speed: const Duration(milliseconds: 100),
                        textAlign: TextAlign.center,
                      );
                    }).toList(),
                  )),
                ]),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder<List<Photo>>(
                future: pexelsApi.getCuratedPhotos(page: 3, perPage: 150),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const WaitingContainer();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final List<Photo> curatedPhotos = snapshot.data!;
                    return MasonryGridView.builder(
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: curatedPhotos.length,
                        itemBuilder: (context, index) {
                          final photo = curatedPhotos[index];
                          final double imageAspectRatio =
                              photo.width / photo.height;
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ImageDetailsScreen(
                                    photo: photo,
                                    curatedPhotos: curatedPhotos,
                                    initialIndex: index,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                        position: offsetAnimation,
                                        child: child);
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                ));
                              },
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: imageAspectRatio,
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: ColorList.colorList[Random().nextInt(ColorList.colorList.length)],
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              photo.src["large"] ?? ''),
                                        ),
                                      ),
                                      child: (photo.url != null)
                                          ? null
                                          : const Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          photo.alt,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.more_horiz_sharp,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          // shareImage(photo.src["large"] ?? '',
                                          //     photo.photographer);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        },
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2));
                  } else {
                    return YourLoadingWidget(
                      child: Container(),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

}
