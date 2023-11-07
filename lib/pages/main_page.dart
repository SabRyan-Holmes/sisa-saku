import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sisasaku/pages/category_page.dart';
import 'package:sisasaku/pages/home_page.dart';
import 'package:sisasaku/pages/transaction_page.dart';

class MainPage extends StatefulWidget {
  final int params;
  const MainPage({super.key, required this.params});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;

  @override
  void initState() {
    updateView(widget.params, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(date),
        );
      }
      currentIndex = index;
      _children = [
        HomePage(
          selectedDate: selectedDate,
        ),
        CategoryPage(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? CalendarAppBar(
              locale: 'id',
              backButton: false,
              accent: Colors.cyan[600],
              firstDate: DateTime.now().subtract(
                Duration(days: 140),
              ),
              lastDate: DateTime.now(),
              onDateChanged: (value) {
                print('Selected date ' + value.toString());
                selectedDate = value;
                updateView(0, selectedDate);
              },
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 16,
                  ),
                  child: Text(
                    'Kategori',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
      body: _children[currentIndex],
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TransactionPage(
                  transactionWithCategory: null,
                ),
              ),
            );
          },
          backgroundColor: Colors.cyan[600],
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: Icon(Icons.home),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: Icon(Icons.list),
            ),
          ],
        ),
      ),
    );
  }
}
