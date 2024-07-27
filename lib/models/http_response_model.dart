import 'package:savyminds/models/games/game_type_matrice_model.dart';

class HttpResponseModel {
  int? count;
  String? next;
  String? previous;
  List? results;
  bool? hasError;
  int? statusCode;

  HttpResponseModel(
      {this.count,
      this.next,
      this.statusCode,
      this.previous,
      this.results,
      this.hasError});

  HttpResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    hasError = json['hasError'] ?? false;
    statusCode = 0;
    next = json['next'] != null
        ? (json['next'] is List)
            ? json['next'][0]
            : json['next']
        : "";
    previous = json['previous'] != null ? json['previous'][0] : "";
    results = json['results'] ?? [];
  }

  checkNextPreviousDataType(dynamic data) {
    if (data.runtimeType == String) {
      return data;
    } else {
      data[0];
    }
  }

  static HttpResponseModel fromJsonList() => HttpResponseModel();

  List<GameTypeMatric> toGameTypeMatricList() {
    List<GameTypeMatric> newList = [];
    if (results != null) {
      for (var value in results!) {
        newList.add(GameTypeMatric.fromJson(value));
      }
    }
    return newList;
  }

  Map<String, dynamic> toJson() {
    return {
      'next': next != null ? [next] : null,
      'previous': previous != null ? [previous] : null,
      'results': results,
      'count': count
    };
  }
}
