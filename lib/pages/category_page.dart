import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:sisasaku/models/category.dart';
import 'package:sisasaku/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  int type = 2;

  final AppDb database = AppDb();
  TextEditingController categoryNameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database
        .into(database.categories)
        .insertReturning(CategoriesCompanion.insert(
          name: name,
          type: type,
          createdAt: now,
          updatedAt: now,
        ));
    print('Masuk pak eko' + row.toString());
  }

  // Get Category
  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  // Update
  Future update(int categoryId, String newName) async {
    return await database.updateCategory(categoryId, newName);
  }

  // Delete
  // Dibikin Langsung di fungsi
  Future delete(int categoryId) async {
    return await database.deleteCategory(categoryId);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                child: Column(children: [
                  Text((isExpense) ? "Add Expense" : "Add Income",
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: (isExpense) ? Colors.red : Colors.green)),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: categoryNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Name"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (category == null) {
                          insert(
                              categoryNameController.text, isExpense ? 2 : 1);
                        } else {
                          update(category.id, categoryNameController.text);
                        }
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        setState(() {
                          categoryNameController.clear();
                        });
                      },
                      child: Text('Save'))
                ]),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Switch(
                    value: isExpense,
                    onChanged: (bool value) {
                      setState(() {
                        isExpense = value;
                        type = value ? 2 : 1;
                      });
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  IconButton(
                      onPressed: () {
                        openDialog(null);
                      },
                      icon: Icon(Icons.add))
                ]),
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
                      print("Ada data : " + snapshot.data!.length.toString());
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  leading: (isExpense == true)
                                      ? Icon(Icons.upload, color: Colors.red)
                                      : Icon(Icons.download,
                                          color: Colors.green),
                                  title: Text(snapshot.data![index].name),
                                  subtitle: Text(''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            openDialog(snapshot.data![index]);
                                          },
                                          icon: Icon(Icons.edit)),
                                      SizedBox(width: 2),
                                      IconButton(
                                          onPressed: () {
                                            delete(snapshot.data![index].id);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text("No Has Data"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("No Has Data"),
                    );
                  }
                }
              })
        ],
      ),
    );
  }
}
