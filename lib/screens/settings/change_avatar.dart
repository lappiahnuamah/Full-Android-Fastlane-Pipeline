import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/avatar_icons.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/widgets/custom_button.dart';
import 'package:savyminds/widgets/page_template.dart';

class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({super.key, required this.selectedAvatar});
  final String selectedAvatar;

  @override
  State<ChangeAvatar> createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  late String selectedAvatar;
  @override
  void initState() {
    selectedAvatar = widget.selectedAvatar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        pageTitle: 'Change Avatar',
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: d.pSW(16)),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: d.pSH(5), vertical: d.pSH(5)),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 5.0, // Spacing between columns
                      mainAxisSpacing: 5.0, // Spacing between rows
                      childAspectRatio: 1.0, // Ratio of width to height
                    ),
                    itemCount: avatarIcons.length,
                    itemBuilder: (context, index) {
                      String avatar = avatarIcons[index];
                      bool isSelected = avatar == selectedAvatar;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatar;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: d.pSH(95),
                              height: d.pSH(95),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.textBlack,
                                ),
                              ),
                              child: SvgPicture.asset(
                                'assets/images/avatars/${avatar}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                  width: d.pSH(95),
                                  height: d.pSH(95),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: d.pSH(10), vertical: d.pSH(10)),
                  height: d.pSH(45),
                  width: double.infinity,
                  child: CustomButton(
                      color: AppColors.blueBird,
                      key: const Key('avatar-change-button'),
                      onTap: () {
                        //TODO: Save avatar
                        final userProvider = Provider.of<UserDetailsProvider>(
                            context,
                            listen: false);
                        userProvider.setAvatarImage(selectedAvatar);
                        Fluttertoast.showToast(
                            msg: 'Avatar sucessfully changed.');

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: d.pSH(16),
                            fontWeight: FontWeight.w500),
                      )),
                ),
                if (Platform.isIOS)
                  SizedBox(
                    height: d.pSH(20),
                  )
              ],
            )));
  }
}
