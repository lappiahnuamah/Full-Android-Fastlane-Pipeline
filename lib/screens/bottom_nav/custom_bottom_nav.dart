import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/categories.dart';
import 'package:savyminds/screens/contest/contest.dart';
import 'package:savyminds/screens/profile/profile.dart';
import 'package:savyminds/screens/records/records.dart';
import 'package:savyminds/screens/solo_quest/solo_quest.dart';
import 'package:savyminds/widgets/page_template.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key, this.currentIndex = 0});
  final int currentIndex;

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        hasTopNav: false,
        bottomNavigationBar: bottomNavigationBar(),
        child: IndexedStack(
          index: currentIndex,
          children: const [
            Categories(),
            SoloQuest(),
            Contest(),
            Records(),
            Profile()
          ],
        ));
  }

  Widget bottomNavigationBar() {
    final bright = Theme.of(context).brightness;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      items: [
        customBottomItem(
            activeIcon: 'assets/icons/bottom_nav/selected_categories.svg',
            icon: 'assets/icons/bottom_nav/categories.svg',
            label: 'Categories'),
        customBottomItem(
            activeIcon: 'assets/icons/bottom_nav/selected_solo_quest.svg',
            icon: 'assets/icons/bottom_nav/solo_quest.svg',
            label: 'Solo Quest'),
        customBottomItem(
            activeIcon: 'assets/icons/bottom_nav/selected_contest.svg',
            icon: 'assets/icons/bottom_nav/contest.svg',
            label: 'Contest'),
        customBottomItem(
            activeIcon: 'assets/icons/bottom_nav/selected_records.svg',
            icon: 'assets/icons/bottom_nav/records.svg',
            label: 'Records'),
        customBottomItem(
            activeIcon: 'assets/icons/bottom_nav/selected_profile.svg',
            icon: 'assets/icons/bottom_nav/profile.svg',
            label: 'Profile'),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      backgroundColor: bright == Brightness.dark
          ? AppColors.kDarkBottomNavBarColor
          : Colors.white,
      selectedItemColor: AppColors.kPrimaryColor,
      unselectedItemColor: AppColors.hintTextBlack,
      selectedLabelStyle: TextStyle(
        fontSize: d.pSW(12),
        fontWeight: FontWeight.w300,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: d.pSW(12),
        fontWeight: FontWeight.w300,
      ),
    );
  }

  //
  BottomNavigationBarItem customBottomItem(
      {required String activeIcon,
      required String icon,
      required String label}) {
    return BottomNavigationBarItem(
      label: label,
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: d.pSH(5)),
        child: SvgPicture.asset(
          icon,
          width: d.pSW(20),
          height: d.pSW(20),
        ),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.symmetric(vertical: d.pSH(5)),
        child: SvgPicture.asset(
          activeIcon,
          width: d.pSW(20),
          height: d.pSW(20),
        ),
      ),
    );
  }
}
