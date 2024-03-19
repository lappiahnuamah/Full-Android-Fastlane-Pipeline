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
    next = json['next'] != null ? json['next'][0] : "";
    previous = json['previous'] != null ? json['previous'][0] : "";

    if (json['results'] != null) {
      results = <dynamic>[];
      json['results'].forEach((v) {
        results!.add(v);
      });
    }
  }

  checkNextPreviousDataType(dynamic data) {
    if (data.runtimeType == String) {
      return data;
    } else {
      data[0];
    }
  }

  static HttpResponseModel fromJsonList() => HttpResponseModel();

  Map<String, dynamic> toJson() {
    return {
      'next': next != null ? [next] : null,
      'previous': previous != null ? [previous] : null,
      'results': results,
      'count': count
    };
  }
}
