# Filtro Laplaciano

## GRUPO E

- Ana Julia Botega
- Carolina Monteiro Quintanilha Adilino
- Enzo Raulino Kretzer
- Henrique Sabanay de Mendonça Momm
- João Bruno dos Santos
- João Lucas Medina Kormann

## DESCRIÇÃO

Este é o nosso projeto de descrição de um sistema que aplica o filtro Laplaciano em uma imagem, desenvolvido para a Atividade Prática 3 da disciplina de Sistemas Digitais na Universidade Federal de Santa Catarina. Tivemos que modelar o circuito do zero, formular a máquina de estados, montar o Bloco Operativo e descrever o código em VHDL.

O circuito funciona com duas memórias, uma de entrada e outra de saída, que armazenam os dados da imagem original e da imagem filtrada, respectivamente. Cada endereço dessas memórias armazena um pixel da imagem. A memória da imagem filtrada é escrita no decorrer dos processos do circuito.

Nosso sistema foi projetado para receber imagens quadradas; dessa forma, os testes foram produzidos em torno disso.

O componente principal para um filtro de imagem é o módulo de convolução, que, no nosso projeto, foi feito especificamente para o filtro laplaciano. Sua descrição não é parametrizável para diferentes filtros.

O kernel utilizado na convolução para o filtro laplaciano foi o seguinte:

| | Coluna 1 | Coluna 2 | Coluna 3 |
|---|:-:|:-:|:-:|
| **Linha 1** | 0 | 1  | 0 |
| **Linha 2** | 1 | -4 | 1 |
| **Linha 3** | 0 | 1  | 0 |

Esse kernel é usado na convolução. Nela, pegamos um pixel central como referência e, com base nele, obtemos seus oito vizinhos. Com todos os 9 pixels, multiplicamos cada um por sua posição correspondente no kernel e, em seguida, somamos todos eles. O valor final será o pixel resultante para a imagem filtrada, e sua posição é baseada na posição do pixel central obtido.


#### SIMULAÇÃO

Para a descrição do circuito, utilizamos o VSCode com a extensão `VHDL & SystemVerilog IDE by Sigasi`, que facilitou o processo com sugestões e uma leve análise do código para tratamento de erros. Com o código pronto, utilizamos o GHDL para analisar e consertar pequenos erros de sintaxe. Posteriormente, também utilizamos o aplicativo para executar nossos testbenches.

Os maiores desafios na descrição do hardware se encontraram na produção do módulo de convolução e em como ele se relacionava com os outros componentes do circuito.

Com o sistema pronto e corrigido após a verificação dos valores obtidos nos testes, partimos para a simulação. Para ela, utilizamos o Quartus II. Assim, obtivemos a frequência do circuito, além de algumas informações sobre o uso da placa.

#### Observações

* **NOVAMENTE**: Nosso sistema foi feito e testado para imagens quadradas. Não garantimos seu funcionamento para tamanhos que não se encaixam nesses padrões.

* Nosso circuito faz a convolução através do método de CROP. Com isso, parte da fidelidade da imagem filtrada é perdida, e sua dimensão acaba sendo menor que a da imagem original. Também destacamos que imagens 2x2 não irão funcionar por causa do método utilizado.

* Queríamos destacar também que, após a AP2, o processo de descrição do hardware se tornou mais fácil. Modelar o projeto ainda foi complicado, porém escrever o código em VHDL, não. Também tivemos mais tempo para explorar o GHDL, além de outras ferramentas que nos auxiliaram na implementação deste projeto.