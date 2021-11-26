<h1 align="center">
  Browness
</h1>

<p align="center">
  <img src="https://img.shields.io/github/last-commit/Arthurcn96/Browness?logo=github&style=for-the-badge">
  <img src="https://img.shields.io/github/repo-size/Arthurcn96/Browness?style=for-the-badge&logo=appveyor">
  <img src="https://img.shields.io/badge/Status-Finalizado-red?style=for-the-badge&logo=appveyor">
</p>

Código de **visão computacinal** através da implementação do cálculo de Browness do [Aimonino](https://iris.unito.it/handle/2318/1564400) para detecção de tons de marron de uma imagem através da aplicação pixel a pixel.


<p align="center">
  <img src="https://user-images.githubusercontent.com/24442087/139354596-77d4426c-e81f-424c-8146-b71348d322f5.png">
</p>


|Processo | Teorico  | Hibrido| Absoluto|
|:-------:|:-----:|:-------:|:-----:|
|K = 0 |![](https://github.com/Arthurcn96/Browness/blob/master/out/TEO/test0%20k=0.png?raw=true)|![](https://github.com/Arthurcn96/Browness/blob/master/out/HIB/test0%20k=0.png?raw=true)|![](https://github.com/Arthurcn96/Browness/blob/master/out/ABS/test0%20k=0.png?raw=true)|

## Desenvolvido
Implementação dos filtros para detecção



 ### Normalizacao
É feito o cálculo de cor `K*R - G - B` em todos o s píxel da imagem a fim de encontrar o píxel de maior intensidade
Uma aplicação de detecção de marrom.

<details close>
  <summary >Clique aqui para ver implementação</summary>
  <markdown>
      
  ```Java
      List<int> intensidadeMaxMin(Image  src, int k){
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

        return [min,max];
      }
  ```

  </markdown>
</details>

___
### Teórico
Normalização Teórica usa a itensidade máxima(r2) e mínima(r1) pra gerar o destribuir os valores de cada Píxel dentro de um panorama que uma tela é capaz de reproduzir.

<details close>
  <summary >Clique aqui para ver implementação</summary>
  <markdown>
      

  ```Java
  int normalizacaoTeorica(int p, int r1, int r2){
    var normalizado = 0;

    p < 0 ? print("P = $p < 0"): '';

    normalizado = (((p - r1)/(r2 - r1))*(255 - 0)).toInt();

    return normalizado;
  }
  ``` 

  </markdown>
</details>
  
___
### Híbrido
O Híbrido é feito com o mesmo princípio da Normalização Teórica, porém ele utiliza o valor absoluto dos resultados da função.
<details close>
  <summary >Clique aqui para ver implementação</summary>
  <markdown>
      

  ```Java
  int normalizacaoHibrida(int p, int r1, int r2){
    var normalizado = 0;

    normalizado = (((p.abs() - r1)/(r2 - r1))*(255 - 0)).toInt();

    return normalizado;
  }
  ```

  </markdown>
</details>

___
### Absoluto
É a normalização mais simplista, onde carrega o valor do resultado da função, e caso seja menor que 0 ou maior que 255, ele altera o resultado pra um desses valores.

  <details close>
  <summary >Clique aqui para ver implementação</summary>
  <markdown>

  ```Java
  int normalizacaoAbsoluta(int result){
        var abs = result.abs();

        result =  abs >= 255 ? 255 : abs;

        return result;
  }
  ```

  </markdown>
</details>
