// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:test/test.dart';
import 'package:intl_phone_field/phone_number.dart';

void main() {
  group('LocalPhoneNumber', () {
    test('create a phone number', () {
      LocalPhoneNumber LocalPhoneNumber =
          LocalPhoneNumber(countryISOCode: "UK", countryCode: "+44", number: "7891234567");
      String actual = LocalPhoneNumber.completeNumber;
      String expected = "+447891234567";

      expect(actual, expected);
      expect(LocalPhoneNumber.isValidNumber(), true);
    });

    test('create a Guernsey number', () {
      LocalPhoneNumber LocalPhoneNumber =
          LocalPhoneNumber(countryISOCode: "GG", countryCode: "+441481", number: "960194");
      String actual = LocalPhoneNumber.completeNumber;
      String expected = "+441481960194";

      expect(actual, expected);
      expect(LocalPhoneNumber.isValidNumber(), true);
    });

    test('look up UK as a country code', () {
      Country country = LocalPhoneNumber.getCountry("+447891234567");
      expect(country.name, "United Kingdom");
      expect(country.code, "GB");
      expect(country.regionCode, "");
    });

    test('look up Guernsey as a country code', () {
      Country country = LocalPhoneNumber.getCountry("+441481960194");
      expect(country.name, "Guernsey");
      expect(country.code, "GG");
      expect(country.regionCode, "1481");
    });

    test('create with empty complete number', () {
      LocalPhoneNumber LocalPhoneNumber = LocalPhoneNumber.fromCompleteNumber(completeNumber: "");
      expect(LocalPhoneNumber.countryISOCode, "");
      expect(LocalPhoneNumber.countryCode, "");
      expect(LocalPhoneNumber.number, "");
      expect(() => LocalPhoneNumber.isValidNumber(), throwsA(const TypeMatcher<NumberTooShortException>()));
    });

    test('create HK  number +85212345678', () {
      LocalPhoneNumber LocalPhoneNumber = LocalPhoneNumber.fromCompleteNumber(completeNumber: "+85212345678");
      expect(LocalPhoneNumber.countryISOCode, "HK");
      expect(LocalPhoneNumber.countryCode, "852");
      expect(LocalPhoneNumber.number, "12345678");
      expect(LocalPhoneNumber.isValidNumber(), true);
    });

    test('Number is too short number +8521234567', () {
      LocalPhoneNumber ph = LocalPhoneNumber.fromCompleteNumber(completeNumber: "+8521234567");
      expect(() => ph.isValidNumber(), throwsA(const TypeMatcher<NumberTooShortException>()));
    });

    test('cannot create from too long number +852123456789', () {
      LocalPhoneNumber ph = LocalPhoneNumber.fromCompleteNumber(completeNumber: "+852123456789");

      expect(() => ph.isValidNumber(), throwsA(const TypeMatcher<NumberTooLongException>()));
    });

    test('create UK LocalPhoneNumber from +447891234567', () {
      LocalPhoneNumber LocalPhoneNumber = LocalPhoneNumber.fromCompleteNumber(completeNumber: "+447891234567");
      expect(LocalPhoneNumber.countryISOCode, "GB");
      expect(LocalPhoneNumber.countryCode, "44");
      expect(LocalPhoneNumber.number, "7891234567");
      expect(LocalPhoneNumber.isValidNumber(), true);
    });

    test('create Guernsey LocalPhoneNumber from +441481960194', () {
      LocalPhoneNumber LocalPhoneNumber = LocalPhoneNumber.fromCompleteNumber(completeNumber: "+441481960194");
      expect(LocalPhoneNumber.countryISOCode, "GG");
      expect(LocalPhoneNumber.countryCode, "441481");
      expect(LocalPhoneNumber.number, "960194");
      expect(LocalPhoneNumber.isValidNumber(), true);
    });

    test('create alpha character in  LocalPhoneNumber from +44abcdef', () {
      expect(() => LocalPhoneNumber.fromCompleteNumber(completeNumber: "+44abcdef"),
          throwsA(const TypeMatcher<InvalidCharactersException>()));
    });

    test('create alpha character in  LocalPhoneNumber from +44abcdef1', () {
      expect(() => LocalPhoneNumber.fromCompleteNumber(completeNumber: "+44abcdef1"),
          throwsA(const TypeMatcher<InvalidCharactersException>()));
    });
  });
}
