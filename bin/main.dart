import 'dart:io';
import 'package:image/image.dart';

import 'Filtro.dart';

void main() {
  List<int> aux;
  var filtro = Filtro();

  // Roda em i fotos do assets o browness com k = 0 até j
  for (var i = 0; i < 1; i++) {
    for (var j = 0; j < 5; j++) {
      final image = decodePng(File('assets/IMD$i.png').readAsBytesSync())!;
      aux = filtro.intensidadeMaxMin(image, j);
      filtro.browness(image, j, FiltroName.Teorico, i, aux[0], aux[1]);
    }
  }
}
