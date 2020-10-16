param DW{E};
param ODW{E};
param auxDW{E};
param Saida{E} default 0.0;
param auxid;
param auxmax;
param Xaux{J1} default 0.0;
param Yaux{J2} default 0.0;
param carregado{J2} default 1.0;
param index;
param Tmaq{Inp} default 0.0;
param Tmaq2{Out} default 0.0;
param aux default 0.0;
param Atraso{E} default 0.0;
param soma;

for {z in E}{
	let auxDW[z]:= W[z]*(r[z]/D[z]);
}

for {a in E}{
 let auxmax:=0;
 	for {b in E}{
 		if auxDW[b]>=auxmax then {
 			let auxmax := auxDW[b];
 			let auxid := b;
 		};
 	} 
 let DW[a]:= auxDW[auxid];
 let ODW[a]:=auxid;
 let auxDW[auxid]:= -1;
}
let index:= 1 ;
for{t in T}{
 for {m in Inp}{
 	if index<= n then{
 		if Tmaq[m]= t then{
 			let aux:= ODW[index];
 			if r[aux]>=t then{
 				let Tmaq[m]:= r[aux]+ P1[aux];
 				let Xaux[aux]:= r[aux]+ P1[aux];
 				let index := index + 1;	
 			}
 			else{
 				let Tmaq[m]:= Tmaq[m]+P1[aux];
 				let Xaux[aux]:= Tmaq[m]+P1[aux];
 				let index:= index+1;
 			}
 			
 		}
 	}
 }
}


for{ a in J1}{
	for{b in J2}{
		let aux:= Xaux[a] * S[a,b];
		if aux>= Yaux[b] then{
			let Yaux[b]:= aux;
			
		}
	}
}

for{t in T}{
	for{m in Out}{
		for{b in J2}{
			if carregado[b]>0 then{
				if t>= Yaux[b] then{
					if t >= Tmaq2[m] then{
					
						if Tmaq2[m]>=Yaux[b] then{
							let Tmaq2[m]:=Tmaq2[m]+P2[b];
							let carregado[b]:=0;
							let Yaux[b]:= Tmaq2[m]+P2[b];
						}
						else{
							let Tmaq2[m]:=Yaux[b]+P2[b];
							let carregado[b]:=0;
							let Yaux[b]:= Yaux[b]+P2[b];
						}
					}
				}
			}
		}
	}
}

for{ a in J1}{
	for{b in J2}{
		for{ e in E}{
			 let aux:= Yaux[b] * V[e,a] * S[a,b];
			 if aux >= Saida[e] then {
			 	let Saida[e]:=aux
			 }			
		}
	}
}

for{ e in E}{
	let aux:= Saida[e]-D[e];
	if aux> Atraso[e] then{
		let Atraso[e]:= aux;
	}
}
let soma:=0;
for{e in E}{
	let soma:= Atraso[e]* W[e] + soma;
}
printf"\n HC FO2  ";
display soma;
printf"Data de entrega e atraso\n";
display Yaux, Atraso;