import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int days = 0;
  int months = 0;
  int years = 0;
  int currentYear = DateTime.now().year;

  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  void calculateDateDifference() {
    if (_areFieldsFilled()) {
      final day = int.parse(dayController.text);
      final month = int.parse(monthController.text);
      final year = int.parse(yearController.text);

      final birthDate = DateTime(year, month, day);
      final currentDate = DateTime.now();

      final lastBirthday = _getLastBirthday(currentDate, birthDate);

      final difference = currentDate.difference(lastBirthday);

      final totalMonths = difference.inDays ~/ 30;
      final remainingDays = difference.inDays % 30;
      int yearss = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        yearss--;
      }

      setState(() {
        years = yearss;
        months = totalMonths;
        days = remainingDays;
      });
    } else {
      _showSnackBar('Please fill all the fields');
    }
  }

  bool _areFieldsFilled() {
    return dayController.text.isNotEmpty &&
        monthController.text.isNotEmpty &&
        yearController.text.isNotEmpty;
  }

  DateTime _getLastBirthday(DateTime currentDate, DateTime birthDate) {
    DateTime lastBirthday =
        DateTime(currentDate.year, birthDate.month, birthDate.day);
    if (lastBirthday.isAfter(currentDate)) {
      lastBirthday =
          DateTime(currentDate.year - 1, birthDate.month, birthDate.day);
    }
    return lastBirthday;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: Colors.red,
        animation: const AlwaysStoppedAnimation(BorderSide.strokeAlignInside),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTextStyle(
          style: GoogleFonts.poppins(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ContainerDate(
                        dayController: dayController,
                        hintText: '24',
                        text: 'DAY',
                        numberFilter: FilteringTextInputFormatter.allow(
                          RegExp(r'^([0-2]?[0-9]|3[01])$'),
                        ),
                      ),
                      ContainerDate(
                        dayController: monthController,
                        hintText: '10',
                        text: 'MONTH',
                        numberFilter: FilteringTextInputFormatter.allow(
                          RegExp(r'^(?:0?[0-9]|1[0-2])$'),
                        ),
                      ),
                      ContainerDate(
                        dayController: yearController,
                        hintText: '1995',
                        text: 'YEAR',
                        limitedText: 4,
                        numberFilter: FilteringTextInputFormatter.allow(
                          RegExp(r'.*'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: calculateDateDifference,
                    child: Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(134, 76, 255, 1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icon-arrow.png',
                          scale: 1.6,
                        )),
                  ),
                  const SizedBox(height: 30),
                  DefaultTextStyle(
                    style: const TextStyle(
                      color: Color.fromRGBO(21, 21, 21, 1),
                      fontSize: 46,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextDateResult(
                          number: years,
                          text: 'Years',
                        ),
                        TextDateResult(
                          number: months,
                          text: 'Months',
                        ),
                        TextDateResult(
                          number: days,
                          text: 'Days',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextDateResult extends StatelessWidget {
  const TextDateResult({
    Key? key,
    required this.number,
    required this.text,
  }) : super(key: key);

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$number',
            style: const TextStyle(
              color: Color.fromRGBO(134, 76, 255, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' $text'),
        ],
      ),
    );
  }
}

class ContainerDate extends StatelessWidget {
  const ContainerDate({
    Key? key,
    required this.dayController,
    required this.hintText,
    required this.text,
    required this.numberFilter,
    this.limitedText = 2,
    this.invalidFilter,
  }) : super(key: key);

  final TextEditingController dayController;
  final String hintText;
  final String text;
  final int? limitedText;
  final List<FilteringTextInputFormatter>? invalidFilter;
  final FilteringTextInputFormatter numberFilter;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Color.fromARGB(255, 122, 122, 122),
            ),
          ),
          SizedBox(
            width: 90,
            child: TextField(
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              controller: dayController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(limitedText),
                FilteringTextInputFormatter.digitsOnly,
                numberFilter,
                if (invalidFilter != null) ...invalidFilter!,
              ],
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 158, 158, 158),
                ),
                hintText: hintText,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
