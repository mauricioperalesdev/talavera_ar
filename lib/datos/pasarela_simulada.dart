import '../dominio/contratos.dart';
import '../dominio/tarjeta.dart';

class PasarelaSimulada implements PasarelaPago {
  static const int limiteCentavos = 5000000; // $50,000
  final Duration latencia;
  final Map<String, ResultadoPago> _vistos = {};

  int cobrosAprobados = 0;
  int _secuencia = 1000;

  PasarelaSimulada({this.latencia = Duration.zero});

  @override
  Future<ResultadoPago> cobrar({
    required int montoCentavos,
    required DatosTarjeta tarjeta,
    required String claveIdempotencia,
  }) async {
    final previo = _vistos[claveIdempotencia];
    if (previo != null) return previo;

    if (latencia > Duration.zero) await Future<void>.delayed(latencia);

    final numero = ValidadorTarjeta.soloDigitos(tarjeta.numero);
    final ResultadoPago r;
    if (montoCentavos <= 0) {
      r = const PagoRechazado('Monto inválido');
    } else if (montoCentavos > limiteCentavos) {
      r = const PagoRechazado('El monto excede el límite permitido');
    } else if (numero == '4000000000000002') {
      r = const PagoRechazado('Tarjeta rechazada por el banco');
    } else if (numero == '4000000000009995') {
      r = const PagoRechazado('Fondos insuficientes');
    } else {
      r = PagoAprobado('PAY-${_secuencia++}');
      cobrosAprobados++;
    }
    _vistos[claveIdempotencia] = r;
    return r;
  }
}