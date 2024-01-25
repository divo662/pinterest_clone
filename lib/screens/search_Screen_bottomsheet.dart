import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBottomSheetContent extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBottomSheetContent({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBottomSheetContentState createState() => _SearchBottomSheetContentState();
}

class _SearchBottomSheetContentState extends State<SearchBottomSheetContent> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 290.w,
          height: 46.h,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(45),
            color: Colors.grey.shade900,
          ),
          child: TextField(
            controller: _searchController,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
            onSubmitted: (query) {
              widget.onSearch(query);
            },
          ),
        ),
      ],
    );
  }
}
