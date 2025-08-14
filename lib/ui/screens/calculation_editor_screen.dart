import 'package:dart_eval/dart_eval.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/calculated_meter.dart';
import 'package:rh_collector/domain/entities/calculation_functions.dart';
import 'package:rh_collector/domain/entities/meter.dart';
import 'package:rh_collector/domain/states/meters_state.dart';
import 'package:rh_collector/l10n/app_localizations.dart';
import 'package:rh_collector/ui/widgets/calculation_editor/calc_action.dart';
import 'package:rh_collector/ui/widgets/input_dialog.dart';

class CalculationEditorScreen extends StatefulWidget {
  const CalculationEditorScreen({
    super.key,
    required this.meter,
    required this.onFormulaChanged,
  });
  final CalculatedMeter meter;
  final Function(List<String> formula) onFormulaChanged;

  @override
  State<CalculationEditorScreen> createState() =>
      _CalculationEditorScreenState();
}

class _CalculationEditorScreenState extends State<CalculationEditorScreen>
    with CalculationFunctions {
  List<CalcAction> formula = [];
  final metersState = Get.find<MetersState>();
  final meters = Get.find<MetersState>().meters;
  bool isFormulaValid = true;
  late AppLocalizations local;

  @override
  void initState() {
    formula = stringToFormula(widget.meter.formula);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (l == null) return const Center(child: CircularProgressIndicator());
    local = l;

    final decodedFormula = widget.meter.parse(formulaToString());
    num result = 0;
    try {
      result = eval(decodedFormula);
      isFormulaValid = true;
    } catch (e) {
      Get.snackbar(local.incorrectFormula, e.toString());
      isFormulaValid = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("${local.formula}:"),
          actions: [
            IconButton(
                onPressed: () {
                  widget.onFormulaChanged(formulaToString());
                  Get.back();
                },
                icon: Icon(Icons.check))
          ],
        ),
        body: Column(
          children: [
            DragTarget<CalcAction>(
              builder: (context, candidateData, rejectedData) {
                final query = MediaQuery.of(context).size;
                return SizedBox(
                  height: 200,
                  width: query.width * 0.95,
                  child: SingleChildScrollView(
                    child: Card(child: Wrap(children: formula)),
                  ),
                );
              },
              // onWillAcceptWithDetails: (d) => true,
              onAcceptWithDetails: (d) => setState(() => formula.add(d.data)),
              onLeave: (i) => setState(() => formula.remove(i)),
            ),
            Text(
              "$decodedFormula = $result",
              style: TextStyle(color: isFormulaValid ? null : Colors.red),
            ),
            Divider(),
            FittedBox(child: Row(children: getActionsWidgets())),
            Divider(),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: getMetersWidgets()),
              ),
            ),
          ],
        ));
  }

  List<Widget> getActionsWidgets() {
    return [
      addAction("+"),
      addAction("-"),
      addAction("*"),
      addAction("/"),
      addAction("("),
      addAction(")"),
      addAction("1"),
    ];
  }

  List<Widget> getMetersWidgets() {
    List<Widget> metersWidgets = [];
    for (final meter in meters) {
      metersWidgets.add(addMeterAction(meter));
    }
    return metersWidgets;
  }

  CalcAction addMeterAction(Meter meter, {String? idx}) {
    final defaultIndexString = idx ?? "n";
    return CalcAction(
        title: meter.name,
        meterId: meter.id,
        indexString: defaultIndexString,
        onDropOnTop: onAddInFront,
        onEditAction: editMeterValueIndex);
  }

  CalcAction addAction(String title, {String? action}) => CalcAction(
      title: title, onDropOnTop: onAddInFront, onEditAction: inputValue);

  onAddInFront({required CalcAction action, required CalcAction target}) {
    final index = formula.indexOf(target);
    setState(() => formula.insert(index, action));
  }

  List<String> formulaToString() {
    List<String> result = [];
    for (final a in formula) {
      result.add(a.action);
    }
    return result;
  }

  List<CalcAction> stringToFormula(List<String> encodedFormula) {
    List<CalcAction> result = [];
    for (final e in encodedFormula) {
      if (e.length == 1) result.add(addAction(e));
      if (e.length > 1 && e.contains("_")) {
        final data = e.split("_");
        final meterId = data[0];
        final idxStr = data[1];
        try {
          final meter = metersState.getMeter(meterId);
          result.add(addMeterAction(meter, idx: idxStr));
        } on Exception catch (e) {
          Get.snackbar("Error", e.toString());
        }
        continue;
      }
      if (e.length > 1) result.add(addAction(e));
    }
    return result;
  }

  editMeterValueIndex(CalcAction item) async {
    final index = formula.indexOf(item);
    if (index == -1) return;
    final meterId = item.meterId;
    if (meterId == null) return;
    final indexString = item.indexString;
    final s = await inputDialog(
        context: context, title: local.lastValueSign, initValue: indexString);

    setState(() {
      if (s == null) return;
      formula[index] = item.copyWith(meterId: meterId, indexString: s);
    });
  }

  inputValue(CalcAction item) async {
    final index = formula.indexOf(item);
    if (index == -1) return;
    final action = item.action;
    final s = await inputDialog(
        context: context, title: local.inputNumber, initValue: action);

    setState(() {
      if (s == null) return;
      formula[index] = item.copyWith(title: s);
    });
  }
}
