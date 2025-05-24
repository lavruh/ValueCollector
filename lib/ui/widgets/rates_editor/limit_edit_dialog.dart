import 'package:flutter/material.dart';
import 'package:rh_collector/l10n/app_localizations.dart';

class LimitEditDialog extends StatefulWidget {
  const LimitEditDialog({super.key, required this.limit, required this.price});
  final int limit;
  final double price;

  @override
  State<LimitEditDialog> createState() => _LimitEditDialogState();
}

class _LimitEditDialogState extends State<LimitEditDialog> {
  TextEditingController limitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    limitController.text = widget.limit.toString();
    priceController.text = widget.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    if(local == null) return Center(child: CircularProgressIndicator());
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Wrap(
          children: [
            TextFormField(
              key: const Key('inputLimit'),
              validator: _limitValidator,
              controller: limitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: local.limit),
            ),
            TextFormField(
              key: const Key('inputPrice'),
              validator: _isEmptyValidator,
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: local.price),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text(local.yes),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final int limit = int.parse(limitController.text);
              final double price = double.parse(priceController.text);
              Navigator.of(context).pop({limit: price});
            }
          },
        ),
        ElevatedButton(
          child: Text(local.no),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  String? _limitValidator(String? value) {
    final isEmpty = _isEmptyValidator(value);
    if (isEmpty != null) {
      return isEmpty;
    }
    int? v = int.tryParse(value!);
    if (v == null || v <= 0) {
      return AppLocalizations.of(context)?.incorrectLimit;
    }
    return null;
  }

  String? _isEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.pleaseEnterText;
    }
    return null;
  }
}
