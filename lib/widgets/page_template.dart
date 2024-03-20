import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';
import 'package:savyminds/utils/route_behaviour.dart';
import 'package:savyminds/widgets/nav_btn_w.dart';
import 'package:savyminds/widgets/twin_text_wn.dart';

class PageTemplate extends StatefulWidget {
  const PageTemplate(
      {Key? key,
      this.statusBarColor = Colors.white,
      this.statusBarTheme = Brightness.light,
      this.statusBarIconTheme = Brightness.dark,
      this.hasTopNav = true,
      this.hasNotice = false,
      this.lightBackgroundColor,
      this.darkBackgroundColor,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.resizeToAvoidBottomInset,
      this.child,
      this.horizontalPadding = 16,
      this.topSpace = 0,
      this.pageTitle = 'Page Title',
      this.isWidgetTitle,
      this.widgetTitle,
      this.navActionItems,
      this.floatingActionBtn,
      this.floatingActionBtnLoc,
      this.noticeIconLoc,
      this.noticeTitle,
      this.noticeMsg,
      this.noticeBgColor,
      this.noticeIconColor = AppColors.kWhite,
      this.onCloseNotice,
      this.onWillPop,
      this.onBackPressed,
      this.foreGroundDecoration,
      this.showBackBtn = true,
      this.showTopSpace = true,
      this.topNavHeight = 80,
      this.topNavIconColor,
      this.backIcon = Icons.arrow_back_rounded,
      this.pageTitleColor = Colors.black,
      this.iconColor = Colors.black,
      this.topNavColor,
      this.pageTitleStyle,
      this.topNavHasImage,
      this.topNavBarImage,
      this.topNoticeWidget,
      this.refreshWidget = const SizedBox(),
      this.showRefreshWidget = false,
      this.bottomNavigationBar,
      this.showStatusBar = true})
      : super(key: key);

  final Color statusBarColor;
  final Brightness statusBarTheme;
  final Brightness statusBarIconTheme;
  final bool hasTopNav, hasNotice;
  final double topSpace;
  final double horizontalPadding;
  final Color? lightBackgroundColor;
  final Color? darkBackgroundColor;
  final Color? noticeBgColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? child;
  final List<Widget>? navActionItems;
  final String pageTitle;
  final bool? isWidgetTitle;
  final Widget? widgetTitle;
  final Color? pageTitleColor;
  final FloatingActionButtonLocation? floatingActionBtnLoc;
  final Widget? floatingActionBtn;
  final String? noticeIconLoc;
  final String? noticeTitle;
  final String? noticeMsg;
  final Color? noticeIconColor;
  final Function()? onCloseNotice;
  final bool Function()? onWillPop;
  final Function()? onBackPressed;
  final Decoration? foreGroundDecoration;
  final bool showBackBtn;
  final bool showTopSpace;
  final double topNavHeight;
  final IconData backIcon;
  final Color? iconColor;
  final Color? topNavColor;
  final Color? topNavIconColor;
  final TextStyle? pageTitleStyle;
  final bool? topNavHasImage;
  final bool? topNavBarImage;
  final bool? resizeToAvoidBottomInset;
  final Widget? topNoticeWidget;
  final Widget refreshWidget;
  final bool showRefreshWidget;
  final Widget? bottomNavigationBar;
  final bool showStatusBar;

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  @override
  Widget build(BuildContext context) {
    widget.showStatusBar
        ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top])
        : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom]);
    Size size = MediaQuery.of(context).size;
    Brightness bright = Theme.of(context).brightness;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        widget.onWillPop?.call();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: widget.bottomNavigationBar ?? const SizedBox(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: bright == Brightness.dark
                  ? AppColors.kDarkAppBarColor
                  : AppColors.kWhiteAppBarColor, //This is disregarded on iOS
              statusBarBrightness: bright == Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
              statusBarIconBrightness: bright == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: Stack(
              children: [
                const GameBackground(),
                Container(
                  height: size.height,
                  foregroundDecoration: widget.foreGroundDecoration,
                  child: Column(
                    children: [
                      widget.hasNotice
                          ? widget.topNoticeWidget ?? const SizedBox()
                          : const SizedBox(),
                      widget.hasTopNav
                          ? Container(
                              color: widget.topNavColor ??
                                  (bright == Brightness.dark
                                      ? AppColors.kDarkAppBarColor
                                      : AppColors.kWhiteAppBarColor),
                              height: d.pSH(widget.topNavHeight),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.showBackBtn
                                      ? NavBtn(
                                          iconColor: widget.topNavIconColor ??
                                              (bright == Brightness.dark
                                                  ? Colors.white
                                                  : AppColors.kDarkCardColor),
                                          onTap: widget.onBackPressed != null
                                              ? widget.onBackPressed!
                                              : () {
                                                  // print('I want to go back.');
                                                  Navigator.pop(context);
                                                },
                                          icon: widget.backIcon,
                                        )
                                      : const SizedBox.shrink(),

//                         icon: backIcon,
//                       ),

                                  SizedBox(
                                    height: d.pSH(12),
                                  ),

                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(
                                      top: size.height * 0.03 /*24.0*/,
                                    ),
                                    child: widget.isWidgetTitle ?? false
                                        ? widget.widgetTitle
                                        : Text(
                                            widget.pageTitle,
                                            style: widget.pageTitleStyle ??
                                                TextStyle(
                                                    fontSize: d.pSW(
                                                        14) /*getScaledDimension(16, Palette.kStandardWidth, size.width)*/,
                                                    fontWeight: FontWeight.w500,
                                                    color: bright ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : AppColors
                                                            .kDarkCardColor),
                                          ),
                                  )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.03 /*24.0*/,
                                        right: size.width * 0.04),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: widget.navActionItems ?? [],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      !widget.hasTopNav && widget.showTopSpace
                          ? SizedBox(
                              height: d.pSH(widget.topSpace),
                            )
                          : const SizedBox.shrink(),
                      Expanded(
                          child: ScrollConfiguration(
                        behavior: RouteBehaviour(),
                        child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: widget.child ?? Container()),
                      ))
                    ],
                  ),
                ),
                widget.showRefreshWidget
                    ? widget.refreshWidget
                    : const SizedBox(),
              ],
            )),
        floatingActionButtonLocation: widget.floatingActionBtnLoc,
        floatingActionButton: widget.floatingActionBtn,
      ),
    );
  }
}

class TopNoticeBarW extends StatefulWidget {
  const TopNoticeBarW(
      {Key? key,
      required this.noticeBgColor,
      required this.noticeIconLoc,
      required this.noticeMsg,
      required this.noticeTitle,
      required this.noticeIconColor,
      this.onCloseNotice,
      this.displayNotice = false})
      : super(key: key);

  final Color? noticeBgColor;
  final Color? noticeIconColor;
  final String? noticeIconLoc;
  final String? noticeMsg;
  final String? noticeTitle;
  final Function()? onCloseNotice;
  final bool displayNotice;

  @override
  TopNoticeBarWState createState() => TopNoticeBarWState();
}

class TopNoticeBarWState extends State<TopNoticeBarW> {
  // bool _hideNotice = false;

  @override
  void initState() {
    // _hideNotice = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      child: widget.displayNotice
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: d.pSH(24),
                ),
                Container(
                  width: size.width,
                  color: widget.noticeBgColor ?? AppColors.kSecondaryColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: d.pSW(
                          16,
                        ),
                        vertical: d.pSH(
                          16,
                        )),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const LinearProgressIndicator(
                                value: 0.5,
                                color: AppColors
                                    .kPrimaryColor, // replace with actual progress value
                              ),
                              SizedBox(
                                height: d.pSH(5),
                              ),
                              TwinText(
                                content: widget.noticeMsg ?? 'Please wait',
                                contentStyle: TextStyle(
                                    fontSize: d.pSW(12),
                                    color: AppColors.kWhite,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: d.pSW(18),
                        ),
                        InkWell(
                          onTap: widget.onCloseNotice ??
                              () {
                                // setState(() {
                                //   _hideNotice = true;
                                // });
                              },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: d.pSW(16),
                              vertical: d.pSH(16),
                            ),
                            child: SvgPicture.asset('assets/images/close.svg',
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                    widget.noticeIconColor ?? AppColors.kWhite,
                                    BlendMode.srcIn)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
