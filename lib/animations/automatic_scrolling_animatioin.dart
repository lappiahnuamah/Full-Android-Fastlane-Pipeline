import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';

class AutoScrollingList extends StatefulWidget {
  final String gameIcon;

  const AutoScrollingList({Key? key, required this.gameIcon}) : super(key: key);
  @override
  _AutoScrollingListState createState() => _AutoScrollingListState();
}

class _AutoScrollingListState extends State<AutoScrollingList>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _controller;
  late final double _scrollExtent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAnimation();
    });
  }

  void startAnimation() {
    _scrollExtent = 50.0; // Adjust the scroll amount as needed
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..addListener(() {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
              _scrollController.offset + _scrollExtent * _controller.value);

          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) {
            _scrollController.jumpTo(0);
          }
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: 14,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.red,
            width: d.pSW(70),
            height: d.pSH(70),
            margin: EdgeInsets.all(10),
            child: SvgPicture.network(
              widget.gameIcon,
              colorFilter:
                  const ColorFilter.mode(Color(0xFF525252), BlendMode.srcIn),
              height: d.pSH(70),
            ),
          );
        },
      ),
    );
  }
}
