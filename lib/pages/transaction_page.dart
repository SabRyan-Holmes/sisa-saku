import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sisasaku/models/database.dart';
import 'package:sisasaku/models/transaction_with_category.dart';
import 'package:sisasaku/pages/main_page.dart';
import 'package:sisasaku/widgets/image_input.dart';
import 'dart:io';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({
    super.key,
    required this.transactionWithCategory,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  late int type;
  final AppDb database = AppDb();

  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  Category? selectedCategory;
  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  String dbDate = '';

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      type = 2;
    }
    super.initState();
  }

  void updateTransactionView(TransactionWithCategory transactionWithCategory) {
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    deskripsiController.text = transactionWithCategory.transaction.name;
    dateController.text = DateFormat('dd-MMMM-yyyy')
        .format(transactionWithCategory.transaction.transaction_date);
    dbDate = DateFormat('yyyy-MM-dd')
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;
    (type == 2) ? isExpense = true : isExpense = false;
    selectedCategory = transactionWithCategory.category;
  }

  Future insert(
      int amount, DateTime date, String deskripsi, int categoryId) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.transactions).insertReturning(
          TransactionsCompanion.insert(
            name: deskripsi,
            category_id: categoryId,
            transaction_date: date,
            amount: amount,
            createdAt: now,
            updatedAt: now,
          ),
        );
    print(row.toString());
  }

  Future update(int transactionId, int amount, int categoryId,
      DateTime transactionDate, String deskripsi) async {
    return await database.updateTransactionRepo(
      transactionId,
      amount,
      categoryId,
      transactionDate,
      deskripsi,
    );
  }

  // Parameter untuk ImageInput
  File? savedImage;
  void savedImages(File image) {
    savedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Transaksi',
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Switch(
                      value: isExpense,
                      onChanged: (bool value) {
                        setState(
                          () {
                            isExpense = value;
                            type = (isExpense) ? 2 : 1;
                            selectedCategory = null;
                          },
                        );
                      },
                      inactiveTrackColor: Colors.green,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.red,
                    ),
                    Text(
                      isExpense ? 'Pengeluaran' : 'Pemasukan',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: TextFormField(
                  controller: amountController,
                  cursorColor: (isExpense) ? Colors.red : Colors.green,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: (isExpense)
                          ? BorderSide(
                              color: Colors.red,
                            )
                          : BorderSide(
                              color: Colors.green,
                            ),
                    ),
                    labelText: 'Jumlah Uang',
                    floatingLabelStyle: TextStyle(
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),

              FutureBuilder<List<Category>>(
                future: getAllCategory(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<Category>(
                            decoration: InputDecoration(
                              hintText: 'Pilih Kategori',
                            ),
                            isExpanded: true,
                            value: selectedCategory,
                            icon: Icon(
                              Icons.arrow_downward,
                            ),
                            items: snapshot.data!.map((Category item) {
                              return DropdownMenuItem<Category>(
                                value: item,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: (Category? value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24.0, horizontal: 18.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Kategori tidak ada'),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MainPage(
                                          params: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Tambah kategori'),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        // (isExpense) ? MaterialStateProperty.all<Color>(Colors.red) :
                                        MaterialStateProperty.all<Color>(
                                            Colors.cyan[600]!),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Text('Kategori tidak ada'),
                        ),
                      );
                    }
                  }
                },
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  cursorColor: (isExpense) ? Colors.red : Colors.green,
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: (isExpense)
                          ? BorderSide(
                              color: Colors.red,
                            )
                          : BorderSide(
                              color: Colors.green,
                            ),
                    ),
                    labelText: 'Pilih Tanggal',
                    floatingLabelStyle: TextStyle(
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2099),
                    );

                    if (pickedDate != Null) {
                      String formattedDate =
                          DateFormat('dd-MMMM-yyyy').format(pickedDate!);
                      dateController.text = formattedDate;
                      String data = DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dbDate = data;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: TextFormField(
                  controller: deskripsiController,
                  cursorColor: (isExpense) ? Colors.red : Colors.green,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: (isExpense)
                          ? BorderSide(
                              color: Colors.red,
                            )
                          : BorderSide(
                              color: Colors.green,
                            ),
                    ),
                    labelText: 'Deskripsi',
                    floatingLabelStyle: TextStyle(
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ImageInput(imagesaveat: savedImages),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    (widget.transactionWithCategory == null)
                        ? insert(
                            int.parse(amountController.text),
                            DateTime.parse(dbDate),
                            deskripsiController.text,
                            selectedCategory!.id,
                          )
                        : await update(
                            widget.transactionWithCategory!.transaction.id,
                            int.parse(amountController.text),
                            selectedCategory!.id,
                            DateTime.parse(dbDate),
                            deskripsiController.text,
                          );

                    // Navigator.pop(context);
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(
                          params: 0,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Simpan',
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        // (isExpense) ? MaterialStateProperty.all<Color>(Colors.red) :
                        MaterialStateProperty.all<Color>(Colors.cyan[600]!),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
