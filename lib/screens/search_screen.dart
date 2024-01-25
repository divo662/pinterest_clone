import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest_clone/screens/search_Screen_bottomsheet.dart';
import 'package:pinterest_clone/widget/api_call_waiting_widget.dart';
import '../api/pexel_api_class.dart';
import '../model/pexel_model.dart';
import '../themes/container_random_colors.dart';
import '../widget/loading_Widget.dart';
import '../widget/loading_indicator.dart';
import 'images_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Photo> _searchResults = [];
  bool _isLoading = false;
  // void shareImage(String imageUrl, String photographer) {
  //   Share.share(
  //     'Check out this photo by $photographer: $imageUrl',
  //     subject: 'Photo Sharing',
  //   );
  // }
  @override
  void initState() {
    super.initState();
  }
  final PexelsApi pexelsApi = PexelsApi(
      apiKey: 'MsB5RufxehOuViswILug2dAoqBtlXvyrRdfA0n1GnLL2MCIMbA2eD8Sk');

  Future<void> _searchPhotos(String query) async {
    try {
      // Existing code...

      final List<Photo> results = await PexelsApi(
          apiKey:
          'MsB5RufxehOuViswILug2dAoqBtlXvyrRdfA0n1GnLL2MCIMbA2eD8Sk')
          .searchPhotos(query);

      if (kDebugMode) {
        print("Search Results: $results");
      } // Add this line for debugging

      setState(() {
        _searchResults = results;
        _isLoading = false; // Move this line inside setState to ensure proper state update.
      });
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print("Error during search: $e");
      } // Add this line for debugging
      if (kDebugMode) {
        print(e.toString());
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return _searchBottomSheet();
                  },
                );
              },
            );
          },
          child: Container(
            width: double.infinity,
            height: 46.h,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(45),
                color: Colors.grey.shade900),
            child:  Row(
              children: [
                Icon(Icons.search, color: Colors.grey.shade300,),
                Text(
                  "Search Pinterest",
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.black,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<List<Photo>>(
            future: pexelsApi.getCuratedPhotos(page: 5, perPage: 150),
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
    );
  }
  Widget _searchBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SearchBottomSheetContent(
                  onSearch: (query) {
                    setState(() {
                      _isLoading = true;
                    });
                    _searchPhotos(query).then((_) {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            if (_isLoading)
              const Center(child: AnimatedCircularContainer())
            else
              Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchResults() {
    return MasonryGridView.builder(
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final photo = _searchResults[index];
          final double imageAspectRatio =
              photo.width / photo.height;
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation,
                      secondaryAnimation) =>
                      ImageDetailsScreen(
                        photo: photo,
                        curatedPhotos: _searchResults,
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
  }

}


