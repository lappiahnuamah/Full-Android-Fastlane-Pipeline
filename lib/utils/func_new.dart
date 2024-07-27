import 'package:flutter/material.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/dimensions.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/dialog_button.dart';
import 'package:savyminds/widgets/twin_text_wn.dart';

double getScaledDimension(
    double desiredDimen, double standardDimen, double deviceDimen) {
  double mxplier = 0;
  double scaledDimen = 0;
  mxplier = desiredDimen / standardDimen;

  scaledDimen = deviceDimen * mxplier;

  return scaledDimen;
}

Widget appDialog(
    {required BuildContext context,
    required String loadingMessage,
    String? orientation}) {
  Size size = MediaQuery.of(context).size;
  final bright = Theme.of(context).brightness;
  return AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    content: Container(
      decoration: BoxDecoration(
        color:
            bright == Brightness.dark ? AppColors.kDarkCardColor : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(getScaledDimension(
            8, Dimensions.kStandardWidth, size.width) /*8*/)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: getScaledDimension(
                24, Dimensions.kStandardHeight, size.height) /*24.0*/,
            horizontal: getScaledDimension(
                24, Dimensions.kStandardWidth, size.width) /*24.0*/
            ),
        child: AppDialogContent(
          loadingMsg: loadingMessage /*loadingMsg!*/ /*'Verifying Account...'*/,
          doDone: false /*true*/,
          doLoading: true /*false*/,
          isDialog: true /*true*/,
          negRespLabel: "",
          posRespLabel: '',
          doneTitle: '',
          doneMsg: '',
          onTap: () {},
          onCancel:
              () {} /*(){
                Navigator.pop(context);
              }*/
          ,
          btnLabel: '',
          loaderSize: 32,
          orientation: orientation ?? "horizontal",
          description: "",
        ),
      ),
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))),
  );
}

Future<String?> buildAlertDialog(
    BuildContext context,
    BuildContext dialogContext,
    Size size,
    String status,
    String msg,
    String compMsg,
    Widget dialogContent,
    bool willPop) {
  return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            content: dialogContent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            actions: const [],
          ),
        );
      });
}

///
///
class AppDialogContent extends StatefulWidget {
  const AppDialogContent(
      {Key? key,
      this.onTap,
      this.onProceed,
      this.doneMsg = 'Operation performed successfully.',
      this.doneTitle = 'Operation Successful',
      this.loadingMsg = 'Performing operation...',
      this.doLoading = true,
      this.doDone = true,
      this.isDialog = false,
      this.onCancel,
      this.posRespLabel = 'Yes',
      this.negRespLabel = 'No',
      this.btnLabel = 'Done',
      this.loaderSize,
      required this.orientation,
      this.description,
      this.loadingMsgStyle,
      this.descriptionStyle})
      : super(key: key);

  final Function()? onTap;
  final String doneTitle;
  final String doneMsg;
  final String loadingMsg;
  final bool doLoading;
  final bool doDone;
  final Function()? onProceed;
  final Function()? onCancel;
  final bool isDialog;
  final String negRespLabel;
  final String posRespLabel;
  final String btnLabel;
  final double? loaderSize;
  final String orientation;
  final String? description;
  final TextStyle? loadingMsgStyle;
  final TextStyle? descriptionStyle;

  @override
  AppDialogContentState createState() => AppDialogContentState();
}

class AppDialogContentState extends State<AppDialogContent> {
  bool _loading = true;
  // String _title = 'PIN Change';
  // String _msg = 'Your PIN change was successful.';

  @override
  void initState() {
    super.initState();
    _loading = widget.doLoading;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _loading
        ? SizedBox(
            width: size.width,
            child: widget.orientation == 'horizontal'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: getScaledDimension(widget.loaderSize ?? 40,
                              Dimensions.kStandardHeight, size.height) /*16*/,
                          width: getScaledDimension(widget.loaderSize ?? 40,
                              Dimensions.kStandardWidth, size.width) /*16*/,
                          child: const CircularProgressIndicator.adaptive(
                            strokeWidth: 2.0,
                            backgroundColor: AppColors.kGrey200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.kPrimaryColor,
                            ),
                          ) /*Image.asset('assets/gif/loading.gif'/*'assets/gif/new_nib_loading.gif'*/,
              width: 14,
              height: 14,
            ),*/
                          ),
                      SizedBox(
                        width: getScaledDimension(
                            12, Dimensions.kStandardWidth, size.width) /*8*/,
                      ),
                      Expanded(
                        child: Text(
                          widget.loadingMsg,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: getScaledDimension(14,
                                Dimensions.kStandardHeight, size.height) /*12*/,
                            fontWeight: FontWeight.w400,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: getScaledDimension(widget.loaderSize ?? 40,
                              Dimensions.kStandardHeight, size.height) /*16*/,
                          width: getScaledDimension(widget.loaderSize ?? 40,
                              Dimensions.kStandardWidth, size.width) /*16*/,
                          child: const CircularProgressIndicator.adaptive(
                            strokeWidth: 2.0,
                            backgroundColor: AppColors.kGrey200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.kPrimaryColor,
                            ),
                          ) /*Image.asset('assets/gif/loading.gif'/*'assets/gif/new_nib_loading.gif'*/,
            width: 14,
            height: 14,
            ),*/
                          ),
                      SizedBox(
                        height: getScaledDimension(
                            8, Dimensions.kStandardWidth, size.width),
                      ),
                      widget.description != null
                          ? TwinText(
                              content: widget.description ?? '',
                              title: widget.loadingMsg,
                              titleStyle: widget.loadingMsgStyle ??
                                  TextStyle(
                                      fontSize: getFontSize(14, size),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.kGrey900),
                              contentStyle: widget.descriptionStyle ??
                                  TextStyle(
                                      fontSize: getFontSize(12, size),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.kGrey900),
                              crossAxisAlignment: CrossAxisAlignment.center,
                            )
                          : Text(
                              widget.loadingMsg,
                              style: widget.loadingMsgStyle ??
                                  TextStyle(
                                      fontSize: getFontSize(14, size),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.kGrey900),
                            )
                    ],
                  ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            // direction: Axis.vertical,
            children: [
                Text(
                  widget.doneTitle /*_title*/ /*'Verify Phone Number'*/,
                  style: TextStyle(
                    fontSize: getScaledDimension(18, Dimensions.kStandardHeight,
                        size.height) /*getFontSize(size, 18)*/,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                    height: getScaledDimension(8, Dimensions.kStandardHeight,
                        size.height) /*8*/ /*calcScaleFactor(16, 0, 0),*/
                    ),
                Text(
                  widget
                      .doneMsg /*_msg*/ /*'An SMS with a 6 digit code'
          ' will be sent to phone number. '*/
                  ,
                  style: TextStyle(
                    fontSize: getScaledDimension(14, Dimensions.kStandardHeight,
                        size.height) /*getFontSize(size, 14)*/,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kGrey900,
                  ),
                ),
                SizedBox(
                    height: getScaledDimension(32, Dimensions.kStandardHeight,
                        size.height) /*32*/ /*calcScaleFactor(16, 0, 0),*/
                    ),
                widget.isDialog
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DialogButton(
                            mainColor: AppColors.kPrimaryColor,
                            labelColor: AppColors.kDarkTopBarColor,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            label: widget.negRespLabel /*'Cancel'*/,
                            labelStyle: TextStyle(
                                fontSize: getScaledDimension(12,
                                    Dimensions.kStandardHeight, size.height),
                                color:
                                    AppColors.kDarkTopBarColor /*Colors.white*/,
                                fontWeight: FontWeight.w500),
                            width: size.width * 0.27,
                          ),
                          DialogButton(
                            mainColor: AppColors.kPrimaryColor,
                            labelColor: AppColors.kWhite,
                            onTap: widget.onTap != null
                                ? widget.onTap!
                                : () {
                                    // Navigator.pop(context);
                                    // Navigator.pop(context);
                                    // launchActivity2(
                                    //     context, WelcomeScreen(waiting: true,)
                                    // );
                                  },
                            label: widget.posRespLabel /*'Delete'*/,
                            labelStyle: TextStyle(
                                fontSize: getScaledDimension(12,
                                    Dimensions.kStandardHeight, size.height),
                                color: AppColors.kWhite /*Colors.white*/,
                                fontWeight: FontWeight.w500),
                            width: size.width * 0.27,
                          ),
                        ],
                      )
                    : DialogButton(
                        onTap: widget.onTap != null ? widget.onTap! : () {},
                        mainColor: AppColors.kPrimaryColor,
                        width: size.width,
                        // width: size.width * ,
                        label: widget.btnLabel.isNotEmpty
                            ? widget.btnLabel
                            : 'Done')
              ]);
  }
}
