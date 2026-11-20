import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../dominio/producto.dart';

class PantallaVerEnTuEspacio extends StatelessWidget {
  final Producto producto;
  const PantallaVerEnTuEspacio({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    if (!producto.tieneModelo3d) {
      return Scaffold(
        appBar: AppBar(title: Text(producto.nombre)),
        body: const Center(child: Text('Este producto aún no tiene modelo 3D.')),
      );
    }
    final ios = producto.modeloUsdz;
    return Scaffold(
      appBar: AppBar(title: Text(producto.nombre)),
      body: Column(children: [
        Expanded(
          child: ModelViewer(
            src: producto.modeloGlb!,
            iosSrc: (ios != null && ios.startsWith('https://')) ? ios : null,
            alt: 'Modelo 3D de ${producto.nombre}',
            ar: true,
            arModes: const ['scene-viewer', 'webxr', 'quick-look'],
            arScale: ArScale.fixed,
            autoRotate: true,
            cameraControls: true,
            disableZoom: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (producto.dimensiones != null)
              Text('Tamaño real: ${producto.dimensiones}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Toca el botón de AR del visor, apunta al piso o la mesa y '
                'mueve el teléfono despacio para que detecte la superficie.'),
          ]),
        ),
      ]),
    );
  }
}