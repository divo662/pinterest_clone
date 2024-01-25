import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest_clone/api/pexel_api_class.dart';
import 'package:pinterest_clone/model/pexel_model.dart';
import 'package:pinterest_clone/themes/container_random_colors.dart';
import 'package:pinterest_clone/widget/api_call_waiting_widget.dart';
import '../model/comment_model.dart';
import '../widget/loading_Widget.dart';
import 'image_full_Screen_mode.dart';

class ImageDetailsScreen extends StatefulWidget {
  final Photo photo;
  final List<Photo> curatedPhotos;
  final int initialIndex;

  const ImageDetailsScreen(
      {super.key,
      required this.photo,
      required this.curatedPhotos,
      required this.initialIndex});

  @override
  State<ImageDetailsScreen> createState() => _ImageDetailsScreenState();
}

class _ImageDetailsScreenState extends State<ImageDetailsScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool isFullScreen = false;
  bool isLiked = false;
  int likeCount = 0;
  bool isFollowing = false;
  TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];
  bool showAllComments = false;
  final PexelsApi pexelsApi = PexelsApi(
      apiKey: 'MsB5RufxehOuViswILug2dAoqBtlXvyrRdfA0n1GnLL2MCIMbA2eD8Sk');

  // void shareImage(String imageUrl, String photographer) {
  //   Share.share(
  //     'Check out this photo by $photographer: $imageUrl',
  //     subject: 'Photo Sharing',
  //   );
  // }
  void followPhotographer() {
    setState(() {
      isFollowing = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.only(bottom: 750),
        dismissDirection: DismissDirection.startToEnd,
        content: Container(
            width: 190.w,
            height: 56.h,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(45),
                color: Colors.white),
            child: Center(
              child: Text(
                "followed ${widget.curatedPhotos[_currentIndex].photographer}",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp),
              ),
            )),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void unfollowPhotographer() {
    setState(() {
      isFollowing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.only(bottom: 750),
        dismissDirection: DismissDirection.endToStart,
        content: Container(
            width: 190.w,
            height: 56.h,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(45),
                color: Colors.white),
            child: Center(
              child: Text(
                "Unfollowed ${widget.curatedPhotos[_currentIndex].photographer}",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp),
              ),
            )),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // void downloadImage(String imageUrl) async {
  //   try {
  //     final status = await Permission.storage.request();
  //     if (status == PermissionStatus.granted) {
  //       final directory = await getExternalStorageDirectory();
  //       final savedDir = directory?.path ?? "your_default_directory";
  //
  //       final taskId = await FlutterDownloader.enqueue(
  //         url: imageUrl,
  //         savedDir: savedDir,
  //         showNotification: true,
  //         openFileFromNotification: true,
  //       );
  //     } else {
  //       if (kDebugMode) {
  //         print("Permission denied");
  //       }
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Download error: $error');
  //     }
  //   }
  // }

  void addComment(String text) {
    setState(() {
      comments.add(Comment(username: 'User', text: text));
    });
    _commentController.clear();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _commentController = TextEditingController();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.curatedPhotos.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        final photo = widget.curatedPhotos[index];
        Widget imageWidget = GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FullScreenImage(imageUrl: photo.src['large']),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: photo.width / photo.height,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  filterQuality: FilterQuality.high,
                  fit: isFullScreen ? BoxFit.cover : BoxFit.cover,
                  image: NetworkImage(photo.src['large']),
                ),
              ),
            ),
          ),
        );

        return GestureDetector(
            onVerticalDragUpdate: (details) {
              // Check if the drag is mostly vertical (adjust sensitivity as needed)
              if (details.primaryDelta != null &&
                  details.primaryDelta! > 10 &&
                  details.primaryDelta! < -10) {
                Navigator.pop(context);
              }
            },
            child: _buildPhotoDetailsScreen(photo, imageWidget));
      },
    );
  }

  Widget _buildPhotoDetailsScreen(Photo photo, Widget imageWidget) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey.shade500,
          size: 30,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
                builder: (BuildContext context) {
                  return _bottomSheetContainer();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isFullScreen
                ? imageWidget
                : AspectRatio(
                    aspectRatio: photo.width / photo.height,
                    child: SizedBox(
                      width: double.infinity,
                      child: imageWidget,
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Badge(
                      alignment: Alignment.centerRight,
                      backgroundColor: Colors.transparent,
                      label: Text(
                        likeCount.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                            likeCount = isLiked ? 1 : 0;
                          });
                        },
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle comment button press
                      },
                      icon: const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // shareImage(photo.src["large"] ?? '', photo.photographer);
                  },
                  icon: const Icon(CupertinoIcons.share, color: Colors.white),
                ),
              ],
            ),
             SizedBox(
              height: 5.h,
            ),
            Divider(
              color: Colors.grey.shade500,
              thickness: 0.8,
            ),
             SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                                radius: 25, child: Icon(CupertinoIcons.person)),
                             SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              photo.photographer,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 15.sp,
                              ),
                            )
                          ]),
                      Container(
                        width: isFollowing ? 120.w : 90.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(45),
                          color:
                              isFollowing ? Colors.white : Colors.grey.shade800,
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              if (isFollowing) {
                                unfollowPhotographer();
                              } else {
                                followPhotographer();
                              }
                            },
                            child: Text(
                              isFollowing ? "Following" : "Follow",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color:
                                    isFollowing ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                   SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    photo.alt,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _viewAndSaveButtonsWidget(photo),
                ],
              ),
            ),
             SizedBox(
              height: 5.h,
            ),
            Divider(
              color: Colors.grey.shade500,
              thickness: 0.8,
            ),
             SizedBox(
              height: 5.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              "U",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          title: Text(
                            comments.isNotEmpty
                                ? comments.first.username
                                : '',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            comments.isNotEmpty
                                ? comments.first.text
                                : '',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      // View More Comments Button
                      if (comments.length > 1 && !showAllComments)
                        IconButton(
                          onPressed: () {
                            // Show BottomSheet with all comments
                            showAllCommentsBottomSheet();
                          },
                          icon: const Icon(
                            Icons.arrow_downward_outlined,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(19),
                                borderSide: const BorderSide(
                                    color: Colors.white)),
                            hintText: 'Add a comment...',
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          onSubmitted: (text) {
                            // Add the comment to the list
                            addComment(text);

                            // Clear the text field after sending the comment
                            _commentController.clear();
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          // Extract the text from the text field
                          final text = _commentController.text;
                          if (text.isNotEmpty) {
                            // Add the comment to the list
                            addComment(text);

                            // Clear the text field after sending the comment
                            _commentController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
             SizedBox(
              height: 5.h,
            ),
            Divider(
              color: Colors.grey.shade500,
              thickness: 0.8,
            ),
             SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More to explore',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder<List<Photo>>(
                      future: pexelsApi.getRelatedPhotos(photo, page: 1, perPage: 50),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const WaitingContainer();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final List<Photo> similarPhotos = snapshot.data!;
                          return MasonryGridView.builder(
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: similarPhotos.length,
                            itemBuilder: (context, index) {
                              final photo = similarPhotos[index];
                              final double imageAspectRatio = photo.width / photo.height;
                              if (kDebugMode) {
                                print('Similar Photo URL: ${photo.src["large"]}');
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => ImageDetailsScreen(
                                          photo: photo, curatedPhotos: similarPhotos, initialIndex: index,
                                        ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);

                                          return SlideTransition(position: offsetAnimation, child: child);
                                        },
                                        transitionDuration: const Duration(milliseconds: 500),
                                      )
                                  );
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
                                            image: NetworkImage(photo.src["large"] ?? ''),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            photo.alt,
                                            style:  GoogleFonts.poppins(
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
                                            // shareImage(photo.src["large"] ?? '', photo.photographer);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                          );
                        } else {
                          return YourLoadingWidget(
                            child: Container(),
                          );
                        }
                      },
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _bottomSheetContainer() {
    return Container(
      height: 350.h,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SizedBox(
            height: 10.h,
          ),
          Center(
            child: Text(
              "Share",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: Colors.white),
            ),
          ),
           SizedBox(
            height: 10.h,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Hide",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: Colors.white),
              )),
           SizedBox(
            height: 5.h,
          ),
          TextButton(
            onPressed: () {
              // downloadImage(widget.curatedPhotos[_currentIndex].src['large']);
            },
            child: Text(
              "Download Image",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
           SizedBox(
            height: 5.h,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Report",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: Colors.white),
              )),
          Center(
            child: Container(
              width: 90.w,
              height: 50.h,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.grey.shade800),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _viewAndSaveButtonsWidget(Photo photo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          child: Container(
              width: 180.w,
              height: 56.h,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.grey.shade800),
              child: Center(
                child: Text(
                  "View",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp),
                ),
              )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FullScreenImage(imageUrl: photo.src['large']),
              ),
            );
          },
        ),
        GestureDetector(
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
                    return Container(
                      height: 600.h,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.white,
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 120),
                                child: Text(
                                  "Save to",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.sp),
                                ),
                              ),
                            ],
                          ),
                           SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 70.h,
                                width: 70.w,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                child: const Center(
                                  child: Icon(
                                    CupertinoIcons.add,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                ),
                              ),
                               SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Create board",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Container(
              width: 180.w,
              height: 56.h,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.red),
              child: Center(
                child: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp),
                ),
              )),
        ),
      ],
    );
  }

  void showAllCommentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      builder: (context) {
        return Container(
          height: 700.h,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${comments.length} ${comments.length == 1 ? 'Comment' : 'Comments'}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp
                ),
              ),
               SizedBox(
                height: 5.h,
              ),
              Divider(
                color: Colors.grey.shade500,
                thickness: 0.8,
              ),
              SizedBox(
                height: 5.h,
              ),
              Column(
                children: comments.map((comment) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        "U",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    title: Text(comment.username,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(comment.text,
                    style: GoogleFonts.poppins(
                        color: Colors.grey.shade100,
                        fontWeight: FontWeight.w500,
                    ),),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}


