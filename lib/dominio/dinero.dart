String formatearPesos(int centavos) {
  final negativo = centavos < 0;
  final abs = centavos.abs();
  final pesos = (abs ~/ 100).toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
      );
  final cents = (abs % 100).toString().padLeft(2, '0');
  return '${negativo ? '-' : ''}\$$pesos.$cents';
}

int porcentaje(int centavos, int pct) => (centavos * pct + 50) ~/ 100;

int ivaIncluido(int totalCentavos, {int tasa = 16}) =>
    (totalCentavos * tasa + (100 + tasa) ~/ 2) ~/ (100 + tasa);