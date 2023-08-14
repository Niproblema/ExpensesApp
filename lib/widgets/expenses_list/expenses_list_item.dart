import 'package:expenses_app/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensesListItem extends StatelessWidget {
  final Expense _expense;

  const ExpensesListItem(this._expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _expense.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    '€${_expense.amount.toStringAsFixed(2)}',
                    //style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(categoryIcons[_expense.category]),
                      const SizedBox(width: 8),
                      Text(_expense.formattedDate),
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}
