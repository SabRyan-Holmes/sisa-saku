# sisasaku

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

-   [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
-   [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Tabel
1.categories
-id
-name
-type
-created_at
-updated_at
-deleted_at

Type
1 : income
2 : expense

2. transactions
   -id
   -name
   -category_id
   -image_path
   -transaction_date
   -amount
   -created_at
   -updated_at
   -deleted_at

Padding(
padding: const EdgeInsets.symmetric(horizontal: 16),
child: Card(
elevation: 10,
child: ListTile(
leading: (isExpense == true)
? Icon(Icons.upload, color: Colors.red)
: Icon(Icons.download, color: Colors.green),
title: Text('Sedekah'),
subtitle: Text(''),
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
SizedBox(width: 2),
IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
],
),
),
),
),
