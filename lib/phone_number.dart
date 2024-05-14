import 'countries.dart';

class NumberTooLongException implements Exception {}

class NumberTooShortException implements Exception {}

class InvalidCharactersException implements Exception {}

class Phonenumber {
  String countryISOCode;
  String countryCode;
  String number;

  Phonenumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
  });

  factory Phonenumber.fromCompleteNumber({required String completeNumber}) {
    if (completeNumber == "") {
      return Phonenumber(countryISOCode: "", countryCode: "", number: "");
    }

    try {
      Country country = getCountry(completeNumber);
      String number;
      if (completeNumber.startsWith('+')) {
        number = completeNumber.substring(1 + country.dialCode.length + country.regionCode.length);
      } else {
        number = completeNumber.substring(country.dialCode.length + country.regionCode.length);
      }
      return Phonenumber(
          countryISOCode: country.code, countryCode: country.dialCode + country.regionCode, number: number);
    } on InvalidCharactersException {
      rethrow;
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      return Phonenumber(countryISOCode: "", countryCode: "", number: "");
    }
  }

  bool isValidNumber() {
    Country country = getCountry(completeNumber);
    if (number.length < country.minLength) {
      throw NumberTooShortException();
    }

    if (number.length > country.maxLength) {
      throw NumberTooLongException();
    }
    return true;
  }

  String get completeNumber {
    return countryCode + number;
  }

  static Country getCountry(String Phonenumber) {
    if (Phonenumber == "") {
      throw NumberTooShortException();
    }

    final validPhonenumber = RegExp(r'^[+0-9]*[0-9]*$');

    if (!validPhonenumber.hasMatch(Phonenumber)) {
      throw InvalidCharactersException();
    }

    if (Phonenumber.startsWith('+')) {
      return countries
          .firstWhere((country) => Phonenumber.substring(1).startsWith(country.dialCode + country.regionCode));
    }
    return countries.firstWhere((country) => Phonenumber.startsWith(country.dialCode + country.regionCode));
  }

  @override
  String toString() => 'Phonenumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';
}
