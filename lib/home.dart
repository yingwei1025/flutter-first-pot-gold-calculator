import 'package:firstpotm/widget/finance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firstpotm/widget/locale_provider.dart';
import 'package:provider/provider.dart';

import 'l10n/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  num _currentM = 0, _targetM = 0, _rate = 5.0, _year = 5;
  late String _perMonthM = '0', _perYearM = '0';
  double kMinWidthOfSmallScreen = 700;
  late TextEditingController _tController1;
  late TextEditingController _tController2;
  late TextEditingController _tController3;
  late TextEditingController _tController4;
  bool isShowBlock = false;

  @override
  void initState() {
    super.initState();
    _tController1 = TextEditingController();
    _tController2 = TextEditingController();
    _tController3 = TextEditingController(text: '$_rate');
    _tController4 = TextEditingController(text: '$_year');
  }

  @override
  void dispose() {
    _tController1.dispose();
    _tController2.dispose();
    _tController3.dispose();
    _tController4.dispose();
    super.dispose();
  }

  void _calSaving() {
    num ans = Finance.pmt(
        rate: _rate / 100, nper: _year, pv: _currentM, fv: -_targetM);
    if (ans > 0 && !ans.isInfinite) {
      setState(() {
        _perYearM = ans.toStringAsFixed(2);
        _perMonthM = (ans / 12).toStringAsFixed(2);
        isShowBlock = true;
      });
    }
  }

  void reset() {
    _tController1.clear();
    _tController2.clear();
    _tController3.clear();
    _tController4.clear();
    setState(() {
      _rate = 0;
      _year = 0;
      _currentM = 0;
      _targetM = 0;
      isShowBlock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      onChgLang(Locale lang) {
        provider.setLocale(lang);
      }

      // var lang = provider.locale ?? Localizations.localeOf(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.first_pot_gold_planner),
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
              tooltip: AppLocalizations.of(context)!.language,
              onSelected: (item) => onChgLang(item),
              itemBuilder: (context) => [
                const PopupMenuItem<Locale>(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                const PopupMenuItem<Locale>(
                  value: Locale('zh'),
                  child: Text('中文'),
                )
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: h * 0.02),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: '${AppLocalizations.of(context)!.cal_ur} ',
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.black)),
                    TextSpan(
                        text: AppLocalizations.of(context)!
                            .first_pot_gold_planner,
                        style: TextStyle(
                            fontSize: 15.0, color: Colors.yellow[900])),
                  ]),
                ),
                SizedBox(height: h * 0.02),
                TextField(
                  controller: _tController1,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _currentM = num.parse(value);
                      });
                      _calSaving();
                    }
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          AppLocalizations.of(context)!.ur_current_saving,
                      prefixIcon: const Icon(Icons.savings_outlined)),
                ),
                SizedBox(height: h * 0.02),
                TextField(
                  controller: _tController2,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _targetM = num.parse(value);
                      });
                      _calSaving();
                    }
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!
                          .ur_target_first_pot_of_gold,
                      prefixIcon: const Icon(Icons.track_changes)),
                ),
                SizedBox(height: h * 0.02),
                TextField(
                  controller: _tController3,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _rate = num.parse(value);
                      });
                      _calSaving();
                    }
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!
                          .estimate_rate_of_return_per_year,
                      prefixIcon: const Icon(Icons.equalizer)),
                ),
                SizedBox(height: h * 0.02),
                TextField(
                  controller: _tController4,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _year = num.parse(value);
                      });
                      _calSaving();
                    }
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!
                          .how_many_years_to_achieve,
                      prefixIcon: const Icon(Icons.trending_up)),
                ),
                SizedBox(height: h * 0.02),
                isShowBlock ? buildCalContainer() : Container(),
                SizedBox(height: h * 0.05),
                Container(
                  child: Image.asset('assets/graphics/pot-of-gold.png'),
                  alignment: Alignment.center,
                ),
                SizedBox(height: h * 0.05)
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          onPressed: reset,
          tooltip: 'Reset',
          child: const Icon(Icons.refresh),
        ),
      );
    });
  }

  Widget buildCalContainer() {
    double w = MediaQuery.of(context).size.width;
    bool isScreenBig =
        MediaQuery.of(context).size.width > kMinWidthOfSmallScreen;
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              height: isScreenBig ? 190.0 : 370.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isScreenBig
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildCalBlock(_perMonthM, true),
                            SizedBox(width: w * 0.05),
                            Text(
                              AppLocalizations.of(context)!.or,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(width: w * 0.05),
                            buildCalBlock(_perYearM, false),
                          ],
                        )
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildCalBlock(_perMonthM, true),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.or,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              const SizedBox(height: 10),
                              buildCalBlock(_perYearM, false),
                            ],
                          ),
                        ),
                  buildFinalWord(),
                ],
              )),
        )
      ],
    );
  }

  Widget buildCalBlock(String saving, bool isMonth) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.you_need_to_save,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.attach_money_outlined,
                size: 30.0,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(saving,
                    style: TextStyle(
                        fontSize: kIsWeb
                            ? saving.length <= 7
                                ? 80
                                : 50
                            : saving.length <= 6
                                ? 70
                                : 40,
                        color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                isMonth
                    ? AppLocalizations.of(context)!.per_month
                    : AppLocalizations.of(context)!.per_year,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFinalWord() {
    var _style = const TextStyle(fontSize: 15.0, color: Colors.black);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: AppLocalizations.of(context)!.to_reach_your, style: _style),
        TextSpan(
            text: ' ${AppLocalizations.of(context)!.first_pot_of_gold}',
            style: TextStyle(fontSize: 15.0, color: Colors.yellow[900])),
        TextSpan(text: ' ${AppLocalizations.of(context)!.of_} ', style: _style),
        TextSpan(
            text: ' \$ $_targetM ',
            style: TextStyle(fontSize: 15.0, color: Colors.yellow[900])),
        TextSpan(text: ' ${AppLocalizations.of(context)!.in_} ', style: _style),
        TextSpan(
            text: ' $_year ',
            style: TextStyle(
                fontSize: 15.0, color: Theme.of(context).primaryColor)),
        TextSpan(
            text: ' ${AppLocalizations.of(context)!.years} ', style: _style),
      ]),
    );
  }
}
