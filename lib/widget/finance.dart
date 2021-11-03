import 'dart:math';

class Finance {
  static num pmt(
      {required num rate,
      required num nper,
      required num pv,
      num fv = 0,
      bool end = true}) {
    final int when = end ? 0 : 1;
    final num temp = pow(1 + rate, nper);
    final num maskedRate = (rate == 0) ? 1 : rate;
    final num fact = (rate == 0)
        ? nper
        : ((1 + maskedRate * when) * (temp - 1) / maskedRate);
    return -(fv + pv * temp) / fact;
  }
}
