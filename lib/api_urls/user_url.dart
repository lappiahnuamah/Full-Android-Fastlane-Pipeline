import '../constants.dart';

class UserUrl {
  static const baseUrl = "$halloaBaseUrl/user/";

  static const String homeSlider = "${baseUrl}homeslider/";

  ///Profile
  static const String profile = "${baseUrl}profile/";

  static const String userDetails = "${baseUrl}user_accounts/";
  static const String updateInfo1 = "${profile}update-info-1/";
  static const String userContactInfo = "${baseUrl}user-contacts/";
  static const String updateBio = "${profile}update-bio/";
  static const String updateNames = "${profile}update-profile/";
  static const String updateProfilePicture = "${profile}update/picture";
  static const String updateCoverImage = '${profile}update/cover-image';
  static const String deleteCoverImage = '${profile}delete-cover-image/';
  static const String deleteProfileImage = '${profile}delete-profile-image/';

  // Gallery
  static const String userGallery = "${baseUrl}user_gallery/";
  static const String userGalleryComment = "${baseUrl}user_gallery_comment/";

//USer
  static const String userUser = "${baseUrl}users/";
  static const String userConnectionRequest =
      "${baseUrl}user-connection-requests/";

  //privacy
  static const String updateAboutPrivacy =
      "${baseUrl}update-about-info-privacy/";
  static const String updateContactPrivacy =
      "${baseUrl}update-contact-info-privacy/";
  static const String updatePersonalPrivacy =
      "${baseUrl}update-personal-info-privacy/";
  static const String updateFullnamePrivacy =
      "${baseUrl}update-fullname-privacy/";

  // Circle and followers
  static const String userCircle = "${baseUrl}user-circle/";
  static const String userFollowship = "${baseUrl}user-followship/";

  // Comment Url
  static const String commentReportReason = '${baseUrl}comment-report-reason/';

  /// Contact otp verification
  static const String userContacts = "${baseUrl}user-contacts/";

  ///
  static const String userHallChange = "${baseUrl}v1/user-change-hall/";

  /// petition
  static const String petitionUrl = '${baseUrl}block-petition/';
}
