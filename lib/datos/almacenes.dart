import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dominio/contratos.dart';
import '../dominio/orden.dart';

class AlmacenCarritoMemoria implements AlmacenCarrito {
  List<LineaGuardada> _datos = [];

  @override
  Future<List<LineaGuardada>> cargar() async => [..._datos];

  @override
  Future<void> guardar(List<LineaGuardada> lineas) async => _datos = [...lineas];
}

class AlmacenSeguroMemoria implements AlmacenSeguro {
  final Map<String, String> _datos = {};

  @override
  Future<String?> leer(String clave) async => _datos[clave];

  @override
  Future<void> escribir(String clave, String valor) async => _datos[clave] = valor;

  @override
  Future<void> borrar(String clave) async => _datos.remove(clave);
}

class OrdenesMemoria implements RepositorioOrdenes {
  final List<Orden> _ordenes = [];

  @override
  Future<void> guardar(Orden orden) async => _ordenes.add(orden);

  @override
  Future<List<Orden>> delUsuario(String usuarioId) async =>
      _ordenes.where((o) => o.usuarioId == usuarioId).toList()
        ..sort((a, b) => b.fecha.compareTo(a.fecha));
}

class AlmacenCarritoPrefs implements AlmacenCarrito {
  static const _clave = 'carrito';

  @override
  Future<List<LineaGuardada>> cargar() async {
    final texto = (await SharedPreferences.getInstance()).getString(_clave);
    if (texto == null) return [];
    try {
      return (jsonDecode(texto) as List).cast<LineaGuardada>();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> guardar(List<LineaGuardada> lineas) async =>
      (await SharedPreferences.getInstance()).setString(_clave, jsonEncode(lineas));
}

class AlmacenSeguroFlutter implements AlmacenSeguro {
  final FlutterSecureStorage _s = const FlutterSecureStorage();

  @override
  Future<String?> leer(String clave) => _s.read(key: clave);

  @override
  Future<void> escribir(String clave, String valor) => _s.write(key: clave, value: valor);

  @override
  Future<void> borrar(String clave) => _s.delete(key: clave);
}