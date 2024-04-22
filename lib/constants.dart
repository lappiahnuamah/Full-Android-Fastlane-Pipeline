// ignore_for_file: constant_identifier_names

//App name
import 'package:savyminds/utils/dimensions.dart';
import 'dart:developer' as dev;

const kAppName = "SavyMinds";

Dimensions d = Dimensions();

lg(dynamic msg) => dev.log("$msg");

//
const kIsLoggedInKey = "IsLoggedIn";
const kAppUser = "appUser";
const kDatabasePermission = "databasePermission";
const kFileDownloads = "downloads";
const kLastMessageIndex = "lastMessageIndex";
const kJobs = "jobs";

const singlePersonImagePlaceHolderURL =
    'https://th.bing.com/th/id/OIP.ST_nOY8n_yt6NnEp_MvvRQAAAA?w=185&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7';
const placeHolderURL2 =
    'https://img.freepik.com/free-photo/close-up-shot-pretty-woman-with-perfect-teeth-dark-clean-skin-having-rest-indoors-smiling-happily-after-received-good-positive-news_273609-1248.jpg?w=1380&t=st=1675154268~exp=1675154868~hmac=ef66cfd1dc8151bd537a2d8182cc3d15b5f21248fcdf26636bc06e5b722bdeb7';

const noImageAvailableURL =
    "https://th.bing.com/th/id/OIP.sIBlnrCls7CDXCVbipzwKgHaHa?w=184&h=185&c=7&r=0&o=5&dpr=1.3&pid=1.7";

// Enums
enum LocalFileType { audio, video, image, document, other, invalid }

//Reaction enums
enum ReactionType { like, love, hate, angry, ok, surprised }

//Constant Flags
const VOICE_NOTE_FLAG = "AUDIO_FILE";
const ONLY_FILES_FLAG = "FILES._.ONLY";
const FRONT_CAMERA_FLAG = "FRONT_CAMERA_FLAG";

const MICROPHONE_RECORD_FLAG =
    "You cannot access recording feature if microphone permission is not granted";
const NO_INTERNET_FLAG =
    "Something went wrong. Please check your internet connection and try again";

const CANT_REACT_ON_MESSAGE_OFFLINE_FLAG =
    "Sorry, you cannot react to a message offline";

const REPLY_TO_RESET_FLAG = 'REPLY@!@#%^TO';

const NETWORK_TIMEOUT = 30;

const WAITING_FOR_MESSAGE = "Waiting for message";
const CHATROOM_NOT_FOUND_ERROR_MESSAGE =
    "Either the specified chatroom does not exist Or you do not have access to it.";

const HALLOA_HELP_URL = "https://bit.ly/terateck-support";

//stage
const halloaBaseUrl = 'https://api.stage.linklounge.dev';
const halloaBaseTurnSeverUrl = 'turn:turn.stage.linklounge.dev:3478';
const halloaBaseTurnSeverUrlHost = 'turn:turn.stage.linklounge.dev';
const halloaBaseTurnSeverUrlUsername = 'halloa_user';
const halloaBaseTurnSeverUrlPassword = 'pas123!(^BY';
const halloaBaseTurnSeverUrlSharedSecret = 'pas123!(^BY';
const halloaBaseTurnSeverUrlPort = '3478';
const halloaSocketUrl = 'wss://api.stage.linklounge.dev';
const halloaPushSocketUrl = 'wss://api.stage.linklounge.dev/ws/push/?token=';
const videoBaseUrl = "https://api.stage.linklounge.dev/video/v1/";
const INVITE_LINK_PREFIX_MINUS_CUSTOM_SCHEME =
    "https://web.stage.linklounge.dev/invite/";
const INVITE_LINK_PREFIX_PLUS_CUSTOM_SCHEME =
    "linklounge://web.stage.linklounge.dev/invite/";
const halloaGameSocketUrl =
    'wss://api.stage.linklounge.dev/ws/game-session/?token=';
const halloaAppleRedirectUrl =
    "https://api.stage.linklounge.dev/accounts/apple/login/callback/";
const halloaAppleClientId = "com.terateck.halloaOauth";  //TODD:Change


// // prod
// const halloaBaseUrl = 'https://api.linklounge.dev';
// const halloaBaseTurnSeverUrl = 'turn:turn.linklounge.dev:3478';
// const halloaBaseTurnSeverUrlHost = 'turn:turn.linklounge.dev';
// const halloaBaseTurnSeverUrlUsername = 'halloa_user';
// const halloaBaseTurnSeverUrlPassword = 'pas123!(^BY';
// const halloaBaseTurnSeverUrlSharedSecret = 'pas123!(^BY';
// const halloaBaseTurnSeverUrlPort = '3478';
// const halloaSocketUrl = 'wss://api.linklounge.dev';
// const halloaPushSocketUrl = 'wss://api.linklounge.dev/ws/push/?token=';
// const videoBaseUrl = "https://api.linklounge.dev/video/v1/";
// const INVITE_LINK_PREFIX_MINUS_CUSTOM_SCHEME =
//     "https://web.linklounge.dev/invite/";
// const INVITE_LINK_PREFIX_PLUS_CUSTOM_SCHEME =
//     "linklounge://web.linklounge.dev/invite/";
// const halloaGameSocketUrl =
//     'wss://api.linklounge.dev/ws/game-session/?token=';
// const halloaAppleRedirectUrl =
//     "https://api.linklounge.dev/accounts/apple/login/callback/";
// const halloaAppleClientId = "com.terateck.halloaOauth";

// const initializationVector = "xg4gtjc21IbYX4cg";
// const secretKey = "gvR7PV1xGrDH2lQo";
