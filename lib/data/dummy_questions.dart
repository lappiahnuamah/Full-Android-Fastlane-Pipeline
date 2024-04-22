import 'package:savyminds/models/games/option_model.dart';
import 'package:savyminds/models/games/question_model.dart';

List<QuestionModel> questionList = [
  QuestionModel(
      id: 1,
      hint:
          'Although the question is a riddle, the answer is a name. The answer is the name of the mother of Kofi and Ama.',
      hasMysteryBox: false,
      hasTimesTwoPoints: false,
      text:
          'If Kofi is twice the age of Ama and Ama is dark, What is the name of their mother?',
      option: [
        OptionModel(
            id: 1,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: true),
        OptionModel(
            id: 2,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 3,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 4,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: false)
      ],
      image: '',
      points: 5,
      isGolden: true,
      hasHint: false,
      questionTime: 15),
  QuestionModel(
      id: 2,
      hint: '',
      hasMysteryBox: true,
      hasTimesTwoPoints: false,
      hasHint: false,
      text:
          'These are some of the hardest trivial out there. You need more than memory to work these out.',
      option: [
        OptionModel(
            id: 1,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: true),
        OptionModel(
            id: 2,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 3,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 4,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: false)
      ],
      image: '',
      points: 5,
      isGolden: true,
      questionTime: 15),
  QuestionModel(
      id: 2,
      hint: '',
      hasMysteryBox: false,
      hasTimesTwoPoints: false,
      hasHint: false,
      text:
          'These are some of the hardest trivial out there. You need more than memory to work these out.',
      option: [
        OptionModel(
            id: 1, text: 'Dog', image: '', question: 1, isCorrect: true),
        OptionModel(
            id: 2, text: 'Cat', image: '', question: 1, isCorrect: false),
        OptionModel(
            id: 3, text: 'Snake', image: '', question: 1, isCorrect: false),
        OptionModel(
            id: 4, text: 'Bird', image: '', question: 1, isCorrect: false)
      ],
      image:
          'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
      points: 5,
      isGolden: true,
      questionTime: 15),
];

List<QuestionModel> swapQuestionList = [
  QuestionModel(
      id: 1,
      hint: '',
      hasMysteryBox: false,
      hasTimesTwoPoints: false,
      text:
          'Swap Question: If Kofi is twice the age of Ama and Ama is dark, What is the name of their mother?',
      option: [
        OptionModel(
            id: 1,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: true),
        OptionModel(
            id: 2,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 3,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 4,
            text: 'One of 2 options',
            image: '',
            question: 1,
            isCorrect: false)
      ],
      image: '',
      points: 5,
      isGolden: true,
      hasHint: false,
      questionTime: 15),
  QuestionModel(
      id: 2,
      hint: '',
      hasMysteryBox: false,
      hasTimesTwoPoints: false,
      hasHint: false,
      text:
          'Swap Question: These are some of the hardest trivial out there. You need more than memory to work these out.',
      option: [
        OptionModel(
            id: 1,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: true),
        OptionModel(
            id: 2,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 3,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: false),
        OptionModel(
            id: 4,
            text: '',
            image:
                'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
            question: 1,
            isCorrect: false)
      ],
      image: '',
      points: 5,
      isGolden: true,
      questionTime: 15),
  QuestionModel(
      id: 2,
      hint: '',
      hasMysteryBox: false,
      hasTimesTwoPoints: false,
      hasHint: false,
      text:
          'Swap Question: These are some of the hardest trivial out there. You need more than memory to work these out.',
      option: [
        OptionModel(
            id: 1, text: 'Dog', image: '', question: 1, isCorrect: true),
        OptionModel(
            id: 2, text: 'Cat', image: '', question: 1, isCorrect: false),
        OptionModel(
            id: 3, text: 'Snake', image: '', question: 1, isCorrect: false),
        OptionModel(
            id: 4, text: 'Bird', image: '', question: 1, isCorrect: false)
      ],
      image:
          'https://api.stage.linklounge.dev/media/game_options/Screenshot_2023-10-11_at_3.55.04PM.png',
      points: 5,
      isGolden: true,
      questionTime: 15),
];
