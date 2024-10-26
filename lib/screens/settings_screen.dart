import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/units_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showTemperatureUnitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Border radius for the SimpleDialog
          ),
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          backgroundColor: Color(0xff373A40),
          title: null,
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updateTempUnit('°C');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    color:
                        Provider.of<UnitData>(context).selectedTempUnit == '°C'
                            ? Colors.grey
                            : Color(0xff373A40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '°C',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    if (Provider.of<UnitData>(context).selectedTempUnit == '°C')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updateTempUnit('°F');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color: Provider.of<UnitData>(context).selectedTempUnit == '°F'
                      ? Colors.grey
                      : Color(0xff373A40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('°F',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                    if (Provider.of<UnitData>(context).selectedTempUnit == '°F')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWindUnitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Border radius for the SimpleDialog
          ),
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          backgroundColor: Color(0xff373A40),
          title: null,
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updateWindUnit('mph');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    color:
                        Provider.of<UnitData>(context).selectedWindUnit == 'mph'
                            ? Colors.grey
                            : Color(0xff373A40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Miles per hour (mph)',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    if (Provider.of<UnitData>(context).selectedWindUnit ==
                        'mph')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updateWindUnit('km/h');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color:
                      Provider.of<UnitData>(context).selectedWindUnit == 'km/h'
                          ? Colors.grey
                          : Color(0xff373A40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kilometers per hour (km/h)',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                    if (Provider.of<UnitData>(context).selectedWindUnit ==
                        'km/h')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPressureUnitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Border radius for the SimpleDialog
          ),
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          backgroundColor: Color(0xff373A40),
          title: null,
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updatePressureUnit('mb');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    color:
                        Provider.of<UnitData>(context).selectedPressureUnit ==
                                'mb'
                            ? Colors.grey
                            : Color(0xff373A40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Millibar (mb)',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    if (Provider.of<UnitData>(context).selectedPressureUnit ==
                        'mb')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updatePressureUnit('inHg');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color: Provider.of<UnitData>(context).selectedPressureUnit ==
                          'inHg'
                      ? Colors.grey
                      : Color(0xff373A40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Inches of mercury (inHg)',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                    if (Provider.of<UnitData>(context).selectedPressureUnit ==
                        'inHg')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrecipitationUnitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Border radius for the SimpleDialog
          ),
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          backgroundColor: Color(0xff373A40),
          title: null,
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updatePrecipitationUnit('mm');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    color: Provider.of<UnitData>(context)
                                .selectedPrecipitationUnit ==
                            'mm'
                        ? Colors.grey
                        : Color(0xff373A40)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Millimeters (mm)',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    if (Provider.of<UnitData>(context)
                            .selectedPrecipitationUnit ==
                        'mm')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  Provider.of<UnitData>(context, listen: false)
                      .updatePrecipitationUnit('inHg');
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  color: Provider.of<UnitData>(context)
                              .selectedPrecipitationUnit ==
                          'in'
                      ? Colors.grey
                      : Color(0xff373A40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Inches (in)',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                    if (Provider.of<UnitData>(context)
                            .selectedPrecipitationUnit ==
                        'in')
                      const Icon(Icons.check, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181C14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              SizedBox(
                height: 20,
              ),
              Text(
                'Settings',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                'Units',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w900,
                    fontSize: 18),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Temperature units',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 19),
                          ),
                          GestureDetector(
                            onTap: _showTemperatureUnitDialog,
                            child: Row(
                              children: [
                                Text(
                                  Provider.of<UnitData>(context)
                                      .selectedTempUnit,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left-side text (Wind speed units)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wind Speed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              ),
                              Text(
                                'units',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                          // Right-side unit text with arrow dropdown
                          GestureDetector(
                            onTap: _showWindUnitDialog, // Method to show dialog
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  // Aligns text to the right
                                  children: [
                                    Text(
                                      Provider.of<UnitData>(context)
                                                  .selectedWindUnit ==
                                              'mph'
                                          ? 'Miles per hour'
                                          : 'Kilometers per hour',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      Provider.of<UnitData>(context)
                                                  .selectedWindUnit ==
                                              'mph'
                                          ? '(mph)'
                                          : '(km/h)',
                                      // Smaller unit abbreviation below
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5),
                                // Space between text and icon
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left-side text (Wind speed units)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atmospheric Pressure',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              ),
                              Text(
                                'units',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                          // Right-side unit text with arrow dropdown
                          GestureDetector(
                            onTap: _showPressureUnitDialog,
                            // Method to show dialog
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  // Aligns text to the right
                                  children: [
                                    Text(
                                      Provider.of<UnitData>(context)
                                                  .selectedPressureUnit ==
                                              'mb'
                                          ? 'Millibar'
                                          : 'Inches of',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      Provider.of<UnitData>(context)
                                                  .selectedPressureUnit ==
                                              'mb'
                                          ? '(mb)'
                                          : 'mercury (inHg)',
                                      // Smaller unit abbreviation below
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5),
                                // Space between text and icon
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left-side text (Wind speed units)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precipitation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              ),
                              Text(
                                'units',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                          // Right-side unit text with arrow dropdown
                          GestureDetector(
                            onTap: _showPrecipitationUnitDialog,
                            // Method to show dialog
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  // Aligns text to the right
                                  children: [
                                    Text(
                                      Provider.of<UnitData>(context)
                                                  .selectedPrecipitationUnit ==
                                              'mm'
                                          ? 'Millimeters'
                                          : 'Inches',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      Provider.of<UnitData>(context)
                                                  .selectedPrecipitationUnit ==
                                              'mm'
                                          ? '(mm)'
                                          : '(in)',
                                      // Smaller unit abbreviation below
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5),
                                // Space between text and icon
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
