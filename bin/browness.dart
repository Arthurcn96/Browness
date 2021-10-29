import 'package:image/image.dart';
import 'dart:io';

void main() {
  List<int> aux;

  // Roda em i fotos do assets o browness com k = 0 até j
  for (var i = 0; i < 1; i++) {
    for (var j = 0; j < 5; j++) {
      final image = decodePng(File('assets/IMD$i.png').readAsBytesSync())!;
      aux = intensidadeMaxMin(image, j);
      browness(image, j, i, aux[0], aux[1]);
    }
  }
}

void espera() {
  Future.delayed(const Duration(seconds: 5));
}

/// Aplicação do indice de marrom
void browness(Image image, int k, int n, int max, int min) {
  var r = 0;
  var g = 0;
  var b = 0;

  var result = 0;

  final p = image.getBytes();

  for (var i = 0, len = p.length; i < len; i += 4) {
    // Carregando os RGB
    r = p[i];
    g = p[i + 1];
    b = p[i + 2];

    // Indice de marrom
    result = (k * r - g - b);

    // Normalizacao dos valores ( entre 0 e 255)

    result = normalizacaoAbsoluta(result);
    // result = normalizacaoHibrida(result, max, min);
    // result = normalizacaoHibridaNova(result, k);
    // result = normalizacaoTeorica(result, max, min);

    r = g = b = result;

    // Salvando o Pixel
    p[i] = r;
    p[i + 1] = g;
    p[i + 2] = b;
  }
  File('out/ABS/test$n k=$k.png').writeAsBytesSync(encodePng(image));
}

///   Retorna o valor de menor e maior intensidade da imagem
List<int> intensidadeMaxMin(Image src, int k) {
  var max = 0;
  var min = 10000;
  var result = 0;
  var r = 0, g = 0, b = 0;

  final p = src.getBytes();

  for (var i = 0, len = p.length; i < len; i += 4) {
    // Carregando os RGB
    r = p[i];
    g = p[i + 1];
    b = p[i + 2];

    // Calculando função
    result = (k * r - g - b);

    //Salvando Máximo e Mínimos
    max = (max > result) ? max : result;
    min = (min < result) ? min : result;
  }

  return [min, max];
}

/// Normalizacao
int normalizacaoTeorica(int p, int r1, int r2) {
  var normalizado = 0;

  normalizado = (((p - r1) / (r2 - r1)) * (255 - 0)).toInt();

  return normalizado;
}

/// Normalizacao utilizando valor absoluto
int normalizacaoHibrida(int p, int r1, int r2) {
  var normalizado = 0;

  normalizado = (((p.abs() - r1) / (r2 - r1)) * (255 - 0)).toInt();

  return normalizado;
}

/// Normalizacao que utiliza valores fixos dado valores de K = 0, 1 ou mais
int normalizacaoHibridaNova(int p, int k) {
  var normalizado = 0;
  var r1, r2;

  r1 = -510;

  if (k == 0) {
    r2 = 0;
  } else if (k == 1) {
    r2 = 255;
  } else {
    r2 = 510;
  }

  normalizado = (((p - r1) / (r2 - r1)) * (255 - 0)).toInt();

  return normalizado;
}

/// Normalizacao simplificada
int normalizacaoAbsoluta(int result) {
  var abs = result.abs();

  result = abs >= 255 ? 255 : abs;

  return result;
}
