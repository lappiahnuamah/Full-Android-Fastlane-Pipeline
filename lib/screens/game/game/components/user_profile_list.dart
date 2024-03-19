import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';

class UserProfileList extends StatelessWidget {
  const UserProfileList({super.key, required this.users});
  final List<AppUser> users;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showUsersDialog(context);
      },
      child: SizedBox(
        height: d.pSH(40),
        width: d.pSH(40) +
            (d.pSH(27) * ((users.length < 6 ? users.length : 6) - 1)),
        child: Align(
          child: Stack(
            alignment: AlignmentDirectional.center,
            // clipBehavior: Clip.none,
            children: [
              ...List.generate(
                users.length < 6 ? users.length : 6,
                (index) {
                  // final user = users[index];
                  return Positioned(
                    left: d.pSH(23) * index,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(d.pSH(28)),
                      child: CircleAvatar(
                        radius: d.pSH(20),
                        child: Image.network(
                          users[index].profileImage ?? '',
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(index == 5 ? Icons.add : Icons.person);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  showUsersDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(d.pSH(20)),
                topRight: Radius.circular(d.pSH(20)),
              ),
              color: bright == Brightness.dark
                  ? AppColors.kDarkBorderColor
                  : AppColors.kGameScaffoldBackground,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: d.pSH(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Participants',
                      style: TextStyle(
                        fontSize: getFontSize(28, size),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Architects_Daughter',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: d.pSH(25),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: d.pSH(20),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(
                          users.length,
                          (index) {
                            // final user = users[index];
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: AppColors.kBorderColor),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: d.pSH(3)),
                              child: ListTile(
                                visualDensity: VisualDensity.comfortable,
                                leading: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(d.pSH(28)),
                                  child: CircleAvatar(
                                    radius: d.pSH(20),
                                    child: Image.network(
                                      users[index].profileImage ?? '',
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person);
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(
                                  users[index].username ?? 'User $index',
                                  style: TextStyle(
                                      color: bright == Brightness.dark
                                          ? AppColors.kGameDarkText2Color
                                          : AppColors.kGameText2Color,
                                      fontSize: getFontSize(22, size),
                                      fontFamily: 'Architects_Daughter',
                                      height: 1.3),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
