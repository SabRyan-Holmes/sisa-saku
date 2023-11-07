import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sisasaku/models/database.dart';
import 'package:sisasaku/models/transaction_with_category.dart';
import 'package:sisasaku/pages/main_page.dart';
import 'package:sisasaku/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  int totalAmount1 = 0;
  int totalAmount2 = 0;
  int rest = 0;
  int result1 = 0;
  int result2 = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final type1 = 1;
    final type1Count = await database.countType(type1);

    if (type1Count > 0) {
      result1 = await database.getTotalAmountForTypeAndDate(type1);
    }

    final type2 = 2;
    final type2Count = await database.countType(type2);

    if (type2Count > 0) {
      result2 = await database.getTotalAmountForTypeAndDate(type2);
    }

    setState(() {
      totalAmount1 = result1;
      totalAmount2 = result2;
      rest = totalAmount1 - totalAmount2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.download,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Pemasukan',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Rp. ' +
                                    (NumberFormat.currency(
                                      locale: 'id',
                                      decimalDigits: 0,
                                    ).format(
                                      totalAmount1,
                                    )).replaceAll('IDR', ''),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.upload,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Pengeluaran',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Rp. ' +
                                    (NumberFormat.currency(
                                      locale: 'id',
                                      decimalDigits: 0,
                                    ).format(
                                      totalAmount2,
                                    )).replaceAll('IDR', ''),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sisa Uang',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Rp. ' +
                                    (NumberFormat.currency(
                                      locale: 'id',
                                      decimalDigits: 0,
                                    ).format(
                                      rest,
                                    )).replaceAll('IDR', ''),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //text transaksi
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Transaksi',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDate(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SingleChildScrollView(
                                child: Card(
                                  elevation: 10,
                                  child: ListTile(
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child:
                                          snapshot.data![index].category.type ==
                                                  2
                                              ? Icon(
                                                  Icons.upload,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.download,
                                                  color: Colors.green,
                                                ),
                                    ),
                                    title: Text(
                                      'Rp. ' +
                                          (NumberFormat.currency(
                                            locale: 'id',
                                            decimalDigits: 0,
                                          ).format(
                                            snapshot.data![index].transaction
                                                .amount,
                                          )).replaceAll('IDR', ''),
                                    ),
                                    subtitle: Text(
                                      snapshot.data![index].category.name +
                                          ' (' +
                                          snapshot
                                              .data![index].transaction.name +
                                          ') ',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shadowColor: Colors.red[50],
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Center(
                                                        child: Column(
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                'Yakin ingin Hapus?',
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    'Batal',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // Navigator.of(
                                                                    //         context,
                                                                    //         rootNavigator:
                                                                    //             true)
                                                                    //     .pop();
                                                                    await database.deleteTransactionRepo(snapshot
                                                                        .data![
                                                                            index]
                                                                        .transaction
                                                                        .id);
                                                                    await Navigator
                                                                        .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                MainPage(
                                                                          params:
                                                                              0,
                                                                        ),
                                                                      ),
                                                                    );
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                    'Ya',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: ((context) =>
                                                    TransactionPage(
                                                      transactionWithCategory:
                                                          snapshot.data![index],
                                                    )),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text('Tidak ada data'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Tidak ada data'),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
