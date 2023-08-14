import 'dart:ffi';
import 'dart:io';

import 'package:expenses_app/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd.MM.yy');

class NewExpense extends StatefulWidget {
  final void Function(Expense) _completionCallback;

  const NewExpense(this._completionCallback, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.food;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text('Amount'), prefixText: '€'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton(
                    items: Category.values
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat.name.toUpperCase(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ))
                        .toList(),
                    onChanged: _onCategoryItemSelected,
                    value: _selectedCategory,
                    //decoration: const InputDecoration(label: Text('Category')),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_formatter.format(_selectedDate)),
                        IconButton(
                          onPressed: _onDatePickerClicked,
                          icon: const Icon(Icons.calendar_month),
                        )
                      ],
                    ),
                  )
                ]),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _onSaveButtonClicked,
                      child: const Text('Save Expense'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  bool shouldUseRowLayout(BoxConstraints constraints) {
    if (constraints.maxWidth > constraints.maxHeight) {
      return true;
    } else if (constraints.maxWidth > 600) {
      return true;
    }
    return false;
  }

  void _onDatePickerClicked() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 1, now.month, now.day);
    final DateTime lastDate = now;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    setState(() {
      if (selectedDate != null) {
        _selectedDate = selectedDate;
      }
    });
  }

  void _onCategoryItemSelected(Category? category) {
    if (category == null) {
      return;
    }
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onSaveButtonClicked() {
    final double? setAmount = double.tryParse(_amountController.text);
    final bool isSetAmountValid = setAmount != null && setAmount > 0;

    if (_titleController.text.trim().isEmpty || !isSetAmountValid) {
      if (Platform.isIOS) {
        showCupertinoDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Invalid input!'),
                  content: const Text('Fill out the form fool.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay :('),
                    )
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Invalid input!'),
                  content: const Text('Fill out the form fool.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay :('),
                    )
                  ],
                ));
      }
      return;
    }

    Expense newExpense = Expense(
      title: _titleController.text,
      amount: setAmount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    widget._completionCallback(newExpense);
    Navigator.pop(context);
  }
}
