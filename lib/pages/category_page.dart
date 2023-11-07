import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sisasaku/models/database.dart';

bool isExpense = true;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    (isExpense)
                        ? 'Tambah kategori pengeluaran'
                        : 'Tambah kategori pemasukan',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: categoryNameController,
                      cursorColor: (isExpense) ? Colors.red : Colors.green,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: (isExpense)
                              ? BorderSide(
                                  color: Colors.red,
                                )
                              : BorderSide(
                                  color: Colors.green,
                                ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintText: hint,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (category == null &&
                          categoryNameController.text != '') {
                        insert(
                          categoryNameController.text,
                          isExpense ? 2 : 1,
                        );
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        setState(() {});
                        categoryNameController.clear();
                      } else {
                        if (category != null &&
                            categoryNameController.text != '') {
                          update(
                            category.id,
                            categoryNameController.text,
                          );
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          setState(() {});
                          categoryNameController.clear();
                        }
                      }
                    },
                    child: Text(
                      'Save',
                    ),
                    style: ButtonStyle(
                      backgroundColor: (isExpense)
                          ? MaterialStateProperty.all<Color>(Colors.red)
                          : MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String hint = 'Tidak boleh kosong';
  TextEditingController categoryNameController = TextEditingController();
  final AppDb database = AppDb();
  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
    print(row);
  }

  int type = isExpense ? 2 : 1;

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: isExpense,
                        onChanged: (bool value) {
                          setState(
                            () {
                              isExpense = value;
                              type = value ? 2 : 1;
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
                  IconButton(
                    onPressed: () {
                      openDialog(null);
                      categoryNameController.clear();
                    },
                    icon: Icon(
                      Icons.add,
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder<List<Category>>(
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
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shadowColor: Colors.red[50],
                                                content: SingleChildScrollView(
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
                                                              onPressed: () {
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
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(
                                                                        'dialog');
                                                                database.deleteCategoryRepo(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id);
                                                                setState(() {});
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
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        openDialog(snapshot.data![index]);
                                      },
                                    ),
                                  ],
                                ),
                                leading: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: (isExpense)
                                      ? Icon(Icons.upload,
                                          color: Colors.redAccent[400])
                                      : Icon(
                                          Icons.download,
                                          color: Colors.greenAccent[400],
                                        ),
                                ),
                                title: Text(snapshot.data![index].name),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Data tidak ada'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Data tidak ada'),
                    );
                  }
                }
              },
              future: getAllCategory(type),
            ),
          ],
        ),
      ),
    );
  }
}
