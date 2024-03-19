class GameUtils {
  GameUtils._();

  static String numberToRank(int number) {
    if (number >= 11 && number <= 13) {
      return '$number' 'th'; // Special case for 11th, 12th, and 13th
    } else {
      int lastDigit = number % 10;
      switch (lastDigit) {
        case 1:
          return '${number}st';
        case 2:
          return '${number}nd';
        case 3:
          return '${number}rd';
        default:
          return '${number}th';
      }
    }
  }
}
