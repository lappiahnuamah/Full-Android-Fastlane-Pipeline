import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:file_picker/file_picker.dart';

import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/functions/files_function.dart';
import 'package:savyminds/functions/user_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/screens/settings/change_avatar.dart';
import 'package:savyminds/screens/settings/components/interest_badge.dart';
import 'package:savyminds/utils/camera/camera_screen.dart';
import 'package:savyminds/utils/camera/fullview.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/transparent_button.dart';
import '../../../utils/func_new.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/load_indicator.dart';

class Personalization extends StatefulWidget {
  const Personalization({
    Key? key,
    this.fromSettingsPage = false,
  }) : super(key: key);
  final bool fromSettingsPage;

  @override
  State<Personalization> createState() => _PersonalizationState();
}

class _PersonalizationState extends State<Personalization> {
  late UserDetailsProvider userProvider;
  late CategoryProvider categoryProvider;
  List<CategoryModel> interests = [];
  List<CategoryModel> selectedCategories = [];

  bool categoriesReady = true;

  TextEditingController searchController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  Future getFavoriteCategories() async {}

  @override
  void initState() {
    userProvider = context.read<UserDetailsProvider>();
    categoryProvider = context.read<CategoryProvider>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ageController.text = userProvider.getUserDetails().ageGroup ?? '';
      getFavoriteFromApi();
      selectedCategories = categoryProvider.favoriteCategories;
      setState(() {});
    });

    super.initState();
  }

  bool savingCategories = false;

  List<String> ageGroups = ["12-15", "16-18", "19-22", ">22"];

  getFavoriteFromApi() async {
    selectedCategories =
        await CategoryFunctions().getFavoriteCategories(context: context) ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.fromSettingsPage,
      child: Stack(children: [
        PageTemplate(
          pageTitle: 'Personalize',
          showBackBtn: widget.fromSettingsPage,
          child: Padding(
            padding: EdgeInsets.only(
                top: d.pSH(15), left: d.pSW(15), right: d.pSW(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              label: 'Avatar',
                              fontWeight: FontWeight.w500,
                              fontSize: d.pSH(15),
                            ),
                            SizedBox(width: d.pSW(50)),
                            Expanded(
                              child: Consumer<UserDetailsProvider>(
                                  builder: (context, value, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: d.pSH(100),
                                      height: d.pSH(100),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                      child:
                                          (value.getUserDetails().avatarImage ??
                                                      '')
                                                  .isNotEmpty
                                              ? SvgPicture.asset(
                                                  'assets/images/avatars/${(value.getUserDetails().avatarImage ?? '').isEmpty ? 'default-avatar.svg' : value.getUserDetails().avatarImage}',
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Stack(
                                                    key: UniqueKey(),
                                                    alignment: Alignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/avatars/default-avatar.svg',
                                                        fit: BoxFit.cover,
                                                      ),
                                                      SizedBox(
                                                          height: d.pSH(25),
                                                          width: d.pSH(25),
                                                          child:
                                                              CircularProgressIndicator())
                                                    ],
                                                  ),
                                                  imageUrl: value
                                                          .getUserDetails()
                                                          .profileImage ??
                                                      '',
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SvgPicture.asset(
                                                    'assets/images/avatars/default-avatar.svg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                    ),
                                    SizedBox(width: d.pSW(30)),
                                    TransparentButton(
                                      title: 'Change',
                                      onTapped: () async {
                                        await changeAvatar(context, value);
                                      },
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: d.pSH(30)),
                        CustomText(
                          label: 'Select your age group',
                          fontWeight: FontWeight.w500,
                          fontSize: d.pSH(15),
                        ),
                        SizedBox(height: d.pSH(20)),
                        CustomTextFieldWithLabel(
                          controller: ageController,
                          hintText: 'Age Group',
                          noPrefix: true,
                          readOnly: true,
                          suffixIcon:
                              const Icon(Icons.arrow_drop_down_outlined),
                          onTap: () {
                            showAgeDialog();
                          },
                        ),
                        SizedBox(height: d.pSH(40)),
                        CustomText(
                          label: 'Select Favorite Categories',
                          fontWeight: FontWeight.w500,
                          fontSize: d.pSH(15),
                        ),
                        SizedBox(height: d.pSH(16)),
                        CustomTextFieldWithLabel(
                          controller: searchController,
                          hintText: 'Search Categories',
                          noPrefix: true,
                          onChanged: (value) {
                            lg("Search category: $value");
                            final c = Provider.of<CategoryProvider>(context,listen: false);
                            c.searchCategories(value ?? '');
                            return '';
                          },
                        ),
                        if (selectedCategories.isNotEmpty)
                          SizedBox(height: d.pSH(16)),
                        if (selectedCategories.isNotEmpty)
                          Padding(
                              padding: EdgeInsets.only(top: d.pSH(15.0)),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...List.generate(
                                      selectedCategories.length,
                                      (index) => Padding(
                                        padding:
                                            EdgeInsets.only(right: d.pSW(8)),
                                        child: CategoryBadge(
                                            onTap: () {
                                              selectedCategories.remove(
                                                  selectedCategories[index]);
                                              setState(() {});
                                            },
                                            isSelected: true,
                                            isFavorites: true,
                                            text:
                                                selectedCategories[index].name),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        SizedBox(height: d.pSH(32)),
                        categoriesReady
                            ? Consumer<CategoryProvider>(
                              builder: (context,value,child) {
                                return Padding(
                                    padding: EdgeInsets.all(d.pSH(8.0)),
                                    child: value
                                            .searchedCategories.isEmpty
                                        ? Container(
                                            height: d.pSH(50),
                                            alignment: Alignment.center,
                                            child: CustomText(
                                              textAlign: TextAlign.center,
                                              label:
                                                  "We could not find this '${searchController.text}' category",
                                            ))
                                        : Wrap(
                                            spacing: d.pSW(10),
                                            runSpacing: d.pSH(10),
                                            children: [
                                              ...List.generate(
                                                value
                                                    .searchedCategories.length,
                                                (index) => CategoryBadge(
                                                  onTap: () {
                                                    if (selectedCategories.contains(
                                                        value
                                                            .searchedCategories[index])) {
                                                      selectedCategories.remove(
                                                          value
                                                              .searchedCategories[index]);
                                                    } else {
                                                      selectedCategories.add(
                                                          value
                                                              .searchedCategories[index]);
                                                    }
                                                    setState(() {});
                                                  },
                                                  text: value
                                                      .searchedCategories[index].name,
                                                  isSelected: selectedCategories
                                                      .any((element) =>
                                                          element.name ==
                                                          value
                                                              .searchedCategories[index]
                                                              .name),
                                                ),
                                              ),
                                            ],
                                          ));
                              }
                            )
                            : Center(
                                child: Container(
                                  height: d.pSH(20),
                                  width: d.pSH(20),
                                  margin: const EdgeInsets.only(top: 20),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.kPrimaryColor),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                if (widget.fromSettingsPage)
                  SizedBox(
                    height: d.pSH(45),
                    width: double.infinity,
                    child: CustomButton(
                        color: AppColors.blueBird,
                        key: const Key('proceed-button'),
                        onTap: () async {
                          saveChanges();
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: d.pSH(16),
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                if (!widget.fromSettingsPage)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: d.pSH(35),
                        width: d.pSW(120),
                        child: CustomButton(
                            color: AppColors.kWhite,
                            key: const Key('skip-button'),
                            onTap: () async {
                              nextScreen(context, CustomBottomNav());
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                  color: AppColors.hintTextBlack,
                                  fontSize: d.pSH(16),
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                      SizedBox(width: d.pSW(30)),
                      SizedBox(
                        height: d.pSH(35),
                        width: d.pSW(120),
                        child: CustomButton(
                            color: AppColors.blueBird,
                            key: const Key('proceed-button'),
                            onTap: () async {
                              saveChanges();
                            },
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: d.pSH(16),
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ],
                  ),
                SizedBox(
                  height: d.pSH(50),
                )
              ],
            ),
          ),
        ),

        ///////////////////////////////////////////////////////////
        ///////////// CIRCULAR PROGRESS INDICATOR///////////////////
        /////////////////////////////////////////////////////////
        savingCategories
            ? LoadIndicator(
                child: appDialog(
                    context: context, loadingMessage: "Saving Changes ..."))
            : const SizedBox()
      ]),
    );
  }

  showAgeDialog() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(d.pSH(20)),
          topRight: Radius.circular(d.pSH(20)),
        )),
        builder: (context) {
          return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ageGroups.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      ageController.text = ageGroups[index];
                    });
                  },
                  title: CustomText(
                    label: ageGroups[index],
                    fontSize: d.pSH(16),
                  ),
                );
              });
        });
  }

  Future<void> changeAvatar(
      BuildContext context, UserDetailsProvider value) async {
    final result = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(d.pSH(20)),
        topRight: Radius.circular(d.pSH(20)),
      )),
      isDismissible: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(d.pSH(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context, "avatar");
                },
                title: CustomText(
                    color: AppColors.borderPrimary, label: "Select an Avatar"),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.pop(context, "gallery");
                },
                title: CustomText(
                    color: AppColors.borderPrimary,
                    label: "Select from Gallery"),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.pop(context, "camera");
                },
                title: CustomText(
                    color: AppColors.borderPrimary, label: "Take a Photo"),
              ),
              if (Platform.isIOS) SizedBox(height: d.pSH(10))
            ],
          ),
        );
      },
    );

    switch ((result ?? '')) {
      case "avatar":
        nextScreen(
            context,
            ChangeAvatar(
              selectedAvatar: value.getUserDetails().avatarImage ?? '',
            ));
        break;
      case "gallery":
        final fileResult = await FilesFunction.pickFile(
            extensions: imageExtensions, fileType: FileType.image);
        lg("File picked : $fileResult");
        if (fileResult != null) {
          nextScreen(
              context, //////////////////// Image or Video Preview ///////////////
              FullViewScreen(
                file: fileResult,
              ));
          //Todo: Upload file to server
        }

        break;
      case "camera":
        final cameras = await availableCameras();

        final fileResult =
            await nextScreen(context, CameraScreen(cameras: cameras));
        lg("Camera file: ${fileResult}");

        break;

      default:
    }
  }

  saveChanges() async {
    setState(() {
      savingCategories = true;
    });

    final selectedIds = selectedCategories.map((e) => e.id).toList();

    final result = await Future.wait([
      if (selectedIds.isNotEmpty)
        CategoryFunctions().favoriteCategories(context, selectedIds),
      if (ageController.text.isNotEmpty)
        UserFunctions.updateAgeGroup(
            context: context, ageGroup: ageController.text),
    ]);

    setState(() {
      savingCategories = false;
    });

    if (result.any((element) => element == true)) {
      Fluttertoast.showToast(msg: 'Changes saved successfully');

      categoryProvider.setFavoriteCategories(selectedCategories);
      if (!mounted) return;
      if (widget.fromSettingsPage) {
        Navigator.pop(context);
      } else {
        nextScreen(context, CustomBottomNav());
      }
    } else {
      Fluttertoast.showToast(msg: 'Failed to save changes');
    }
  }
}
