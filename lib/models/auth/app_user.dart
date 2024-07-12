import 'package:savyminds/models/user_register_model.dart';

class AppUser {
  int? id;
  final int? outerId;
  final String? fullname;
  final String? username;
  String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? dob;
  final String? gender;
  final String? country;
  final String? countryCode;
  final String? status;
  final int? role;
  String? accessToken;
  String? refreshToken;
  final String? city;
  String? profileImage;
  String? coverImage;
  String? aTokenExpireDate;
  String? rTokenExpireDate;
  bool? isUserBlocked;
  final String? hallName;
  bool? isNotificationOff;
  bool? isActive;
  bool? isOnline;
  String? lastSeen;
  bool? isApproved;
  int? chatroomId;
  bool? isAssociatedToHalloa;
  bool? isBlocked;
  String? isBlockedUntil;
  String? blockReason;

  AppUser(
      {this.id,
      this.chatroomId,
      this.fullname,
      this.email,
      this.phoneNumber,
      this.username,
      this.dob,
      this.gender,
      this.status,
      this.country,
      this.countryCode,
      this.role,
      this.accessToken,
      this.refreshToken,
      this.city,
      this.profileImage,
      this.coverImage,
      this.outerId,
      this.displayName,
      this.rTokenExpireDate,
      this.aTokenExpireDate,
      this.isUserBlocked,
      this.hallName,
      this.isNotificationOff,
      this.isActive,
      this.isOnline,
      this.lastSeen,
      this.isApproved,
      this.isAssociatedToHalloa,
      this.blockReason,
      this.isBlocked,
      this.isBlockedUntil});

// Receive from login
  static AppUser fromJson(Map<String, dynamic> json) => AppUser(
        id: json['user']['profile']['id'],
        outerId: json['user']['id'],
        fullname: json['user']['profile']['fullname'],
        username: json['user']['username'],
        email: json['user']['email'],
        dob: json['user']['profile']['dob'],
        gender: json['user']['profile']['gender'],
        status: json['user']['profile']['status'],
        accessToken: json['access'],
        refreshToken: json['refresh'],
        city: json['user']['profile']['city'],
        profileImage: json['user']['profile']['image'],
        coverImage: json['user']['profile']['cover_image'],
        rTokenExpireDate: json['refresh_expiration'],
        aTokenExpireDate: json['access_expiration'],
        hallName: json['user']['profile']['hall_name'],
        isActive: json['user']['is_active'] ?? false,
        isOnline: json['user']['is_online'] ?? false,
        isApproved: json['user']['is_approved'] ?? false,
        isAssociatedToHalloa:
            json['user']['is_associated_to_savvyminds'] ?? false,
        isBlocked: json['user']['is_blocked'] ?? false,
        isBlockedUntil: json['user']['is_blocked_until'],
        blockReason: json['user']['block_reason'] ?? '',
        displayName: json['user']['profile']['display_name'],
      );

  static AppUser fromSecureJson(Map<String, dynamic> json) => AppUser(
        id: json['profile']['id'],
        outerId: json['id'],
        fullname: json['profile']['fullname'],
        displayName: json['profile']['display_name'],
        username: json['username'],
        email: json['email'],
        dob: json['profile']['dob'],
        gender: json['profile']['gender'],
        status: json['profile']['status'],
        city: json['profile']['city'],
        profileImage: json['profile']['image'],
        coverImage: json['profile']['cover_image'],
        rTokenExpireDate: json['refresh_expiration'],
        aTokenExpireDate: json['access_expiration'],
        hallName: json['profile']['hall_name'],
        isActive: json['is_active'] ?? false,
        isOnline: json['is_online'] ?? false,
        isApproved: json['is_approved'] ?? false,
        isAssociatedToHalloa: json['is_associated_to_savvyminds'] ?? false,
        isBlocked: json['is_blocked'] ?? false,
        isBlockedUntil: json['is_blocked_until'],
        blockReason: json['block_reason'] ?? '',
      );

// Receive from profile page
  static AppUser fromUserDetails(Map<String, dynamic> json) => AppUser(
        id: json['user']['id'],
        outerId: json['id'],
        chatroomId: json['chatroom_id'],
        fullname: json['user']['fullname'],
        username: json['username'],
        email: json['email'],
        country: json['user']['profile']['country'],
        countryCode: json['user']['profile']['country_code'],
        dob: json['user']['dob'],
        gender: json['user']['gender'],
        status: json['user']['status'],
        hallName: json['user']['hall_name'],
        city: json['user']['city'],
        profileImage: json['user']['image'],
        coverImage: json['user']['cover_image'],
        isUserBlocked: json['is_user_blocked'],
        isActive: json['is_active'] ?? false,
        isOnline: json['is_online'] ?? false,
        isApproved: json['is_approved'] ?? false,
        isAssociatedToHalloa: json['is_associated_to_linklounge'] ?? false,
        lastSeen: json['last_seen'],
        isNotificationOff: json['user']['is_notification_off'] ?? false,
        isBlocked: json['is_blocked'] ?? false,
        isBlockedUntil: json['is_blocked_until'],
        blockReason: json['block_reason'] ?? '',
      );

// Receive from user list
  static AppUser fromUserList(Map<String, dynamic> json) => AppUser(
      id: json['id'],
      outerId: json['user_account'],
      fullname: json['fullname'],
      displayName: json['display_name'],
      username: json['username'],
      email: json['email'],
      dob: json['dob'],
      gender: json['gender'],
      status: json['status'],
      hallName: json['hall_name'],
      city: json['city'],
      profileImage: json['image'],
      coverImage: json['cover_image'],
      isNotificationOff: json['is_notification_off']);

  // User Registration
  static AppUser fromUserModel(UserRegisterModel user) => AppUser(
        fullname: user.fullname,
        username: user.username,
        email: user.email,
        phoneNumber: user.phoneNumber,
      );

  Map<String, dynamic> toAppUserMap() {
    return {
      "username": username,
      "email": email,
      "user": {
        "fullname": fullname,
        "phone_number": phoneNumber,
        "dob": dob,
        "gender": gender,
        "status": status,
        "city": city,
        "role": role,
        'cover_image': coverImage,
        'display_name': displayName,
      }
    };
  }
}
