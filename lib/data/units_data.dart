import 'package:flutter/foundation.dart';

class UnitData extends ChangeNotifier {
  String _selectedTempUnit = '°C';
  String _selectedWindUnit = 'mph';
  String _selectedPressureUnit = 'mb';
  String _selectedPrecipitationUnit = 'mb';

  String get selectedTempUnit => _selectedTempUnit;

  String get selectedWindUnit => _selectedWindUnit;

  String get selectedPressureUnit => _selectedPressureUnit;

  String get selectedPrecipitationUnit => _selectedPrecipitationUnit;

  void updateTempUnit(String newUnit) {
    _selectedTempUnit = newUnit;
    notifyListeners();
  }

  void updateWindUnit(String newUnit) {
    _selectedWindUnit = newUnit;
    notifyListeners();
  }

  void updatePressureUnit(String newUnit) {
    _selectedPressureUnit = newUnit;
    notifyListeners();
  }

  void updatePrecipitationUnit(String newUnit) {
    _selectedPrecipitationUnit = newUnit;
    notifyListeners();
  }
}
