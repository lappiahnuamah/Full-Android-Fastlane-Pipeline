class NumberUtils {
  String convertToK(int value) {
    double newValue = value / 1000;
    if (newValue >= 1) {
      return "${newValue}k";
    } else {
      return "${value.toInt()}";
    }
  }

  String formatNumberToKAndM(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 10000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toString();
    }
  }
}
