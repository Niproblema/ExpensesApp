import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/widgets/expenses_list/expenses_list_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> _expenses;

  final void Function(Expense) _removeExpenseCallback;

  const ExpensesList(this._expenses, this._removeExpenseCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(_expenses[index]),
        onDismissed: (_) {
          _removeExpenseCallback(_expenses[index]);
        },
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        child: ExpensesListItem(_expenses[index]),
      ),
    );
  }
}
