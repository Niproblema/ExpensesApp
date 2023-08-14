import 'dart:math';
import 'dart:ui';

import 'package:expenses_app/widgets/chart/chart.dart';
import 'package:expenses_app/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenses = [
    Expense(
      amount: 99.99,
      category: Category.food,
      title: 'Ice cream night.',
      date: DateTime.now(),
    ),
    Expense(
      amount: 19.99,
      category: Category.food,
      title: 'Monthly food cap.',
      date: DateTime.now(),
    ),
    Expense(
      amount: 420,
      category: Category.travel,
      title: 'Flight fare to Mallorca.',
      date: DateTime.now(),
    ),
    Expense(
      amount: 69,
      category: Category.leisure,
      title: 'Gaming.',
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    if (_expenses.isEmpty) {
      mainContent = const Center(child: Text('No expenses found.'));
    } else {
      mainContent = ExpensesList(_expenses, _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter expense tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: shouldUseRowLayout()
          ? Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _expenses,
                  ),
                ),
                Expanded(child: mainContent),
              ],
            )
          : Column(
              children: [
                Chart(
                  expenses: _expenses,
                ),
                Expanded(child: mainContent),
              ],
            ),
    );
  }

  bool shouldUseRowLayout() {
    final Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      return true;
    } else if (size.width > 600) {
      return true;
    }
    return false;
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (ctx) => NewExpense(_addExpense),
    );
  }

  void _addExpense(Expense newExpense) {
    setState(() {
      _expenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expenseToRemove) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final int expenseIndex;
    expenseIndex = _expenses.indexOf(expenseToRemove);
    setState(() {
      _expenses.remove(expenseToRemove);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense deleted.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            int insertionIndex = min(_expenses.length, expenseIndex);

            _expenses.insert(insertionIndex, expenseToRemove);
          });
        },
      ),
    ));
  }
}
