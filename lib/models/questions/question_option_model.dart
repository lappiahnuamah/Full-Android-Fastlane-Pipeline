import 'package:equatable/equatable.dart';



class QuestionOption extends Equatable {
  final int id;
  final String image;
  final String text;
  final int question;
  final bool isCorrect;

  const QuestionOption(
      {required this.id,
      required this.image,
      required this.isCorrect,
      required this.question,
      required this.text});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] ?? 0,
      question: json['question'] ?? 0,
      image: json['image'] ?? "",
      text: json['text'] ?? "",
      isCorrect: json['is_correct'] ?? false,
    );
  }

  toMap() {
    return {
      'id': id,
      'text': text,
      'image': image,
      'is_correct': isCorrect,
      'question': question
    };
  }

  @override
  List<Object?> get props => [id, text, image, question, isCorrect];

  @override
  bool get stringify => true;
}
