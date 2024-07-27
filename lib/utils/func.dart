import 'package:flutter/material.dart';
import 'package:savyminds/utils/dimensions.dart';
import 'package:intl/intl.dart';

double getFontSize(double dimension, Size size) {
  return getScaledDimension(dimension, Dimensions.kStandardWidth, size.width);
}

String? formatDate(String? dateString) {
  // If date is null return null

  if (dateString == null) {
    return null;
  }
  DateTime dateTime = DateTime.parse(dateString);

  // Format the date using the DateFormat class
  String formattedDate = DateFormat('MMMM d').format(dateTime);

  // Return the formatted date
  return formattedDate;
}

String? formatDateWithYear(String? dateString) {
  // If date is null return null
  if (dateString == null) {
    return null;
  }
  DateTime dateTime = DateTime.parse(dateString);

  // Format the date using the DateFormat class
  String formattedDate = DateFormat('MMMM d, y').format(dateTime);

  // Return the formatted date
  return formattedDate;
}

double getScaledDimension(
    double desiredDimen, double standardDimen, double deviceDimen) {
  double mxplier = 0;
  double scaledDimen = 0;
  mxplier = desiredDimen / standardDimen;

  scaledDimen = deviceDimen * mxplier;

  return scaledDimen;
}
