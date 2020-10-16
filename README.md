# Crossdocking

 O problema de crossdocking � um problema de sequenciamento de caminh�oes em uma esta��o de carga e descarga de ve�culos 
 
## Considera��es

 A formula��o para esse problema � indexado ao tempo e utiliza uma heur�stica construtiva gulosa.

## O Problema 
![Cd](/imagem/cd.png)
Em um centro de crossdockig os caminh�es chegam  nas docas de 
entrada com diversos produtos e os mesmos devem ser encaminhados para os 
caminh�es de sa�da . Os caminh�es i devem ser direcionados 
para uma doca dispon�vel. Cada caminh�o i de entrada possui um conjunto j de 
caminh�es de sa�da que deve atender (Sij > 0). Logo, o caminh�o de sa�da j s� 
pode come�ar a ser carregado quando seus caminh�es de entrada i est�o totalmente
descarregados. Os caminh�es de entrada possuem uma data de chegada r (antes disso
eles n�o est�o dispon�veis). O n�mero de docas de entrada (maq1) e de sa�da (maq2)
� conhecido, bem como o n�mero de caminh�es de entrada (nv1) e de sa�da (nv2). O 
tempo de descarga e carga de cada caminh�o � conhecido e definido como p. 
Inicialmente, os gestores de produ��o devem minimizar a previs�o de sequenciamento 
do dia tentando entregar tudo o mais breve. Dado isso, cada produto passa a ter uma
data de entrega limite (d), e uma penalidade por atraso (w) estabelecidas. Dado isso, 
ao longo do dia deve-se verificar a posi��o prevista de chegada de cada caminh�o (r). 
Esta posi��o � atualizada horahora, casa ocorra algum atraso impactante (viola��o do 
caminho cr�tico), o sequenciamento deve ser alterado visando minimizar a data 
prometida ponderando a import�ncia de cada cliente (min WT).

## Uso
 utilizando o console do AMPl com o comando
```bash
	include run.run
```