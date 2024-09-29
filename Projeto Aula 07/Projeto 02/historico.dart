class Historico {
  String? hDolarHigh;
  String? hDolarLow;

  Historico({
    this.hDolarHigh,
    this.hDolarLow,
  });

  Historico.fromJson(Map<String, dynamic> json) {
    hDolarHigh = json['high'];
    hDolarLow = json['low'];
  }
}
