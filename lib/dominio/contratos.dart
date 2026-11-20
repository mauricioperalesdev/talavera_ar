import 'orden.dart';
import 'producto.dart';
import 'tarjeta.dart';
import 'usuario.dart';

typedef LineaGuardada = Map<String, Object?>;

abstract class RepositorioCatalogo {
  Future<List<Producto>> listar();
  Future<Producto?> porId(String id);
  Future<void> descontar(String id, int cantidad);
}

abstract class RepositorioOrdenes {
  Future<void> guardar(Orden orden);
  Future<List<Orden>> delUsuario(String usuarioId);
}

abstract class AlmacenCarrito {
  Future<List<LineaGuardada>> cargar();
  Future<void> guardar(List<LineaGuardada> lineas);
}

abstract class AlmacenSeguro {
  Future<String?> leer(String clave);
  Future<void> escribir(String clave, String valor);
  Future<void> borrar(String clave);
}

sealed class ResultadoPago {
  const ResultadoPago();
}

class PagoAprobado extends ResultadoPago {
  final String referencia;
  const PagoAprobado(this.referencia);
}

class PagoRechazado extends ResultadoPago {
  final String motivo;
  const PagoRechazado(this.motivo);
}

abstract class PasarelaPago {
  Future<ResultadoPago> cobrar({
    required int montoCentavos,
    required DatosTarjeta tarjeta,
    required String claveIdempotencia,
  });
}

abstract class ServicioAuth {
  Future<Usuario> registrar({
    required String nombre,
    required String correo,
    required String password,
  });
  Future<Usuario> iniciarSesion({required String correo, required String password});
  Future<Usuario?> restaurarSesion();
  Future<void> cerrarSesion();
  Future<Usuario> actualizarPerfil(Usuario usuario);
}