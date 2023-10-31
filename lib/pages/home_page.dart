import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Income
                    Row(children: [
                      Container(
                          child: Icon(Icons.download, color: Colors.green),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5))),

                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Income',
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                              textAlign: TextAlign.left),
                          SizedBox(height: 7),
                          Text('Rp.3.800.000',
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                              textAlign: TextAlign.left)
                        ],
                      )
                      // Container(
                      //     child: Icon(Icons.outbond, color: Colors.green),
                      //     decoration: BoxDecoration(
                    ] //         color: Colors.white,
                        ), //         borderRadius: BorderRadius.circular(5))),

                    // Expense
                    Row(children: [
                      Container(
                          child: Icon(Icons.upload, color: Colors.red),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5))),

                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Expense',
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                              textAlign: TextAlign.left),
                          SizedBox(height: 7),
                          Text('Rp.3.800.000',
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                              textAlign: TextAlign.left)
                        ],
                      )
                      // Container(
                      //     child: Icon(Icons.outbond, color: Colors.green),
                      //     decoration: BoxDecoration(
                    ] //         color: Colors.white,
                        ), //         borderRadius: BorderRadius.circular(5))),
                  ]),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Transactions",
              style: GoogleFonts.montserrat(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // List Transaksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                title: Text('Rp.20.000'),
                subtitle: Text('Makan Siang'),
                leading: Icon(Icons.upload, color: Colors.red),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Icon(Icons.edit),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                title: Text('Rp.17.000.000'),
                subtitle: Text('Gaji Bulanan'),
                leading: Icon(Icons.download, color: Colors.green),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Icon(Icons.edit),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
