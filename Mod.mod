## DEFINICAO
	param n;          # n produtos(n)
	param nv1;        # quantidade de caminhão de entrada (nv1)
	param nv2;        # quantidade de caminhão de saída   (nv2)
	param m1;         # m1 docas de descarregamento (maq1)
	param m2;         # m2 docas de carregamento (maq2)
	
## Conjuntos
	set J2:={1..nv2}; # K conjunto de veículos de saída
	set J1:={1..nv1}; # L conjunto de veículos de chegada (entrada)
	set E:={1..n};    # E conjunto de produtos
	set Inp:={1..m1}; # F conjunto de docas de entrada
	set Out:={1..m2} ;# H conjunto de docas de saída

## Parametros do problema
	param P1{J1} default 0.0;   # P1 tempo de processamento do job j no estágio 1
	param P2{J2} default 0.0;   # P2 tempo de processamento do job j no estágio 2
	param W{E} default 0.0;     # W penalidade por ataraso na entrega do produto e
	param S{J1,J2} default 0.0; # relação de precedencia entre os jobs de entrada j1 com os de saída j2
	param D{E} default 0.0;     # D data limite de entrega de cada cliente e
	param r{J1} default 0.0 ;   # r data de disponibilidade de veículo de entrega(r)
	param V{E,J1} default 0.0;  # V a relação entre os produtos de cada cliente que chega em cada caminhão J1

##Estimativa de horizonte de tempo
	param Ti := sum{i in J1} P1[i]+ sum{j in J2} P2[j];   # Horizonte de tempo , soma do processamento de todos os jobs
	set T:={0..Ti};                                       #  conjunto tempo
	
## Variáveis de decisão 
	var X{J1,T}, binary;               # recebe 1 se o veículo j1 de entrada é processada no tempo t 
	var Y{J2,T}, binary;               # recebe 1 se o veículo j2 de saída é processado no tempo t
	var L2{J2},>=0;                    # momento de liberação do job j2
	var Cmax,>=0;                      # tempo máximo até ralizar a liberação de todos os veiculos 
	var C{J2},>=0;				       # tempo de saída para entrega de cada caminhão em J2
	var Cp{E},>=0;				       # tempo de saída para entrega de cada cliente e
	var At{E},>=0;				       # tempo de atraso para atender o cliente e
	
## Função objetivo
	# fase 1
	 minimize FO: Cmax;
	# fase 2
	 minimize FO2: sum{e in E} At[e]*W[e];
	 
## Restrições do problema
  # Restrições gerais
	s.t. r1{j in J1}: sum{t in {0..Ti-P1[j]}} X[j,t] = 1;    					        # cada descarregamento deve iniciar em apenas um instante de tempo
	s.t. r2{j in J2}: sum{t in {0..Ti-P2[j]}} Y[j,t] = 1;     					        # cada carregamento deve iniciar em apenas um instante de tempo
	s.t. r3{t in T}: sum{j in J1} sum{ s in max(0, t-P1[j]+1 )..t} X[j,s] <= m1;        # cada caminhão deve ser descarregado em apenas uma doca
	s.t. r4{t in T}: sum{j in J2} sum{ s in max(0, t-P2[j]+1 )..t} Y[j,s] <= m2;        # cada caminhão deve ser carregado em apenas uma doca
	s.t. r5{j in J2, k in J1}: L2[j] >= sum{t in T} (t + P1[k]) * X[k,t] * S[k,j];      # restrição de precedencia, o tempo de liberação do job em J2 deve ser posterios aos seus precedentes
	s.t. r6{ k in J1}: sum{t in T} (t + P1[k]) * X[k,t] >= r[k]+P1[k]; #  o job em J1 só pode começar quando o veículo chega e está disponível
	s.t. r7{j in J2}: sum{ t in 0..Ti-P2[j]} t * Y[j,t] >= L2[j];				        # cada job do segundo estágio, o carregamento, só pode começar após os produtos serem liberados do primeiro  
  
  # Restrição para a fase 1
	s.t. r8{j in J2}: P2[j] + sum{ t in 0..Ti-P2[j]} t * Y[j,t] <= Cmax;         # a variável Cmax deve ser a maior data de conclusão
  
  # Restrições para a fase 2
	s.t. r9{j in J2}: P2[j] + sum{ t in 0..Ti-P2[j]} t * Y[j,t] <= C[j];		 # a variável C en J2 deve ser a maior data de conclusão de cada caminhão de saída
	s.t. r10{j in J2,e in E, k in J1}: Cp[e]>= V[e,k] * S[k,j]* C[j];            # a data de entrega de cada cliente e relacionada com os produtos que vem em cada caminhão de entrada Vej e a relação de atribuição das cargas entre o caminhão de chegada e saída Sij e a data de saida de cada caminhão Cj
	s.t. r11{e in E}: At[e] >=  Cp[e]- D[e];									 # tempo de atraso, data limite de entrega De - tempo que o produto saiu para entrega
	end;
	