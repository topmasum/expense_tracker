import 'package:expenss_track/expensemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expensemodel.dart';
class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  String select='';
  List<String>Category=['Food', 'Transport', 'Shopping', 'Entertainment', 'Bills'];
  final List<Expense> _expense=[];
  double total=0.0;
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime date = DateTime.now();

  void _showbox(BuildContext context) {

    showModalBottomSheet(context: context, builder: (context){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(items: Category.map((category)=>DropdownMenuItem(value: category,child: Text(category),)).toList(),
              onChanged: (value)=>select=value!,
              decoration: InputDecoration(labelText: 'Please Enter category'),),
            SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                  ),
                  onPressed:(){
                    if(titleController.text.isNotEmpty && amountController.text.isNotEmpty && select.isNotEmpty){
                      _addexp(titleController.text,
                          double.parse(amountController.text),
                          date,
                          select);
                      titleController.clear();
                      amountController.clear();
                      select = '';
                      date = DateTime.now();
                      Navigator.pop(context);

                    }

                  },

                  child: Text('Add Expense',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),)),

            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      );

    });
  }
  void _addexp(String title, double amount, DateTime date, String category) {
    setState(() {
      _expense.add(Expense(
        Title: title,
        amount: amount,
        date: date,
        category: category,
      ));
      total += amount;
    });

  }
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Entertainment':
        return Icons.movie;
      case 'Bills':
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.deepPurple,
        // actions: [
        //   IconButton(onPressed: ()=> _showbox(context),
        //       icon: Icon(Icons.add_circle_outline,
        //     color: Colors.white,
        //     size: 30,
        //   )),
        // ],
      ),
      body:Column(
        children: [
          Center(
            child: Card(
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 50,
                  left: 20,
                  right: 20,
                ),
                child: Text('Total Expense: $total',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _expense.length,
                itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(
                          _getCategoryIcon(_expense[index].category),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      trailing: Text(
                        '\$${_expense[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),

                      title: Text(_expense[index].Title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMEd().format(_expense[index].date),
                      ),
                    ),
                  );
                }),
          ),
          //Image.asset('assets/images/logo.png', width: 150, height: 150)

        ],
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showbox(context),
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add,color: Colors.white,),
      ),

    );
  }
}
