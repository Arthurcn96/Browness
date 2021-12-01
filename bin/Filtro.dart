import 'package:image/image.dart';
import 'dart:io';

enum FiltroName { Teorico, Absoluto, Hibrido, NovoHibrido }

class Filtro {
  /// Aplicação do indice de marrom
  /// image : Imagem que o filtro sera aplicado
  ///
  /// `k` : Valor do k utilizado na formula
  ///
  /// `n` : Iteracao oque esta ocorrendo
  ///
  /// `max` : Valor do Pixel de maior intensidade
  ///
  /// `min` : Valor do Pixel de menor intensidade
  void browness(
      Image image, int k, FiltroName filtro, int n, int max, int min) {
    var r = 0;
    var g = 0;
    var b = 0;
    var result = 0;
    var out = 'out/';

    final p = image.getBytes();

    for (var i = 0, len = p.length; i < len; i += 4) {
      // Carregando os RGB
      r = p[i];
      g = p[i + 1];
      b = p[i + 2];

      // Indice de marrom
      result = (k * r - g - b);

      switch (filtro) {
        case FiltroName.Absoluto:
          result = normalizacaoAbsoluta(result);
          out += out.length < 5 ? 'ABS' : '';
          break;

        case FiltroName.Hibrido:
          result = normalizacaoHibrida(result, max, min);
          out += out.length < 5 ? 'HIB' : '';
          break;

        case FiltroName.NovoHibrido:
          result = normalizacaoHibridaNova(result, k);
          out += out.length < 5 ? 'NEW' : '';
          break;

        case FiltroName.Teorico:
          result = normalizacaoTeorica(result, max, min);
          out += out.length < 5 ? 'TEO' : '';
          break;

        default:
          break;
      }
      // Salvando o Pixel
      p[i] = result;
      p[i + 1] = result;
      p[i + 2] = result;
    }
    File('$out/test$n k=$k.png').writeAsBytesSync(encodePng(image));
  }

  ///   Retorna o valor de menor e maior intensidade da imagem
  ///
  ///   `src` : Imagem
  ///
  ///   `k` : Valor de K utilizado na funcao
  List<int> intensidadeMaxMin(Image src, int k) {
    var max = 0;
    var min = 10000;
    var result = 0;
    var r = 0, g = 0, b = 0;

    // Transforma a imagem em uma lista RGBA
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
  ///
  /// `p` : Valor resultado da funcao no Pixel
  ///
  /// `r1` : Intensidade maxima da imagem
  ///
  /// `r2` : Intensidade minima da imagem
  int normalizacaoTeorica(int p, int r1, int r2) {
    var normalizado = 0;

    normalizado = (((p - r1) / (r2 - r1)) * (255 - 0)).toInt();

    return normalizado;
  }

  /// Normalizacao utilizando valor absoluto
  ///
  /// `p` : Valor resultado da funcao no Pixel
  ///
  /// `r1` : Intensidade maxima da imagem
  ///
  /// `r2` : Intensidade minima da imagem
  int normalizacaoHibrida(int p, int r1, int r2) {
    var normalizado = 0;

    normalizado = (((p.abs() - r1) / (r2 - r1)) * (255 - 0)).toInt();

    return normalizado;
  }

  /// Normalizacao que utiliza valores fixos dado valores de K = 0, 1 ou mais
  ///
  /// `p` : Valor resultado da funcao no Pixel
  ///
  /// `k` : Valor do k utilizado na formula
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
  ///
  /// `result` : Valor resultado da funcao no Pixel
  int normalizacaoAbsoluta(int p) {
    var abs = p.abs();

    p = abs >= 255 ? 255 : abs;

    return p;
  }
}
