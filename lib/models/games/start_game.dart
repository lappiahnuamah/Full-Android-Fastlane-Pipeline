class StartGameModel {
  int? id;
  int? numberOfQuestion;
  String title;
  String gameMode;
  String? code;
  bool? started;
  // List<QuestionModel> questions;
  DateTime? dateCreated;

  StartGameModel({
    this.id,
    required this.title,
    required this.gameMode,
    this.code,
    this.numberOfQuestion,
    this.started,
    //required this.questions,
    this.dateCreated,
  });

  factory StartGameModel.fromJson(Map<String, dynamic> json) {
    return StartGameModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      gameMode: json['game_mode'] ?? "",
      code: json['code'] ?? "",
      numberOfQuestion: json['no_of_question'] ?? 0,
      started: json['started'] ?? false,
      // questions: ((json['questions'] ?? []) as List)
      //     .map((e) => QuestionModel.fromJson(e))
      //     .toList(),
      dateCreated: DateTime.parse(json['date_created']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['game_mode'] = gameMode;
    data['code'] = code;
    data['no_of_question'] = numberOfQuestion;
    data['started'] = started;
    //   data['questions'] = questions;
    data['date_created'] = dateCreated;
    return data;
  }
}
