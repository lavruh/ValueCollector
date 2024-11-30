import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rh_collector/domain/entities/meter_rate.dart';
import 'package:rh_collector/domain/states/rates_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rh_collector/ui/widgets/rates_editor/meter_rate_widget.dart';

class MeterRatesEditScreen extends StatelessWidget {
  const MeterRatesEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.meterRates),
        actions: [IconButton(onPressed: _addRate, icon: const Icon(Icons.add))],
      ),
      body: GetX<RatesState>(builder: (state) {
        if (state.rates.isEmpty) {
          return Container();
        }

        return ListView.builder(
          itemCount: state.rates.length,
          itemBuilder: (context, i) {
            return Slidable(
              child: MeterRateWidget(
                meterRate: state.rates[i],
                updateCallback: (MeterRate rate) =>
                    state.updateRate(rate: rate),
              ),
              endActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  icon: Icons.delete_forever,
                  backgroundColor: Colors.red,
                  onPressed: (context) =>
                      state.removeRate(rate: state.rates[i]),
                )
              ]),
            );
          },
        );
      }),
    );
  }

  void _addRate() {
    Get.find<RatesState>().addRate(rate: MeterRate.empty());
  }
}
